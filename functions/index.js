const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sharp = require('sharp');
const crypto = require('crypto');
const stripeLib = require('stripe');
const speakeasy = require('speakeasy');
const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));
const STRIPE_API_KEY = process.env.STRIPE_API_KEY || '';
const stripe = stripeLib(STRIPE_API_KEY);
admin.initializeApp();

exports.generateThumbnail = functions.storage.object().onFinalize(async (object) => {
  const filePath = object.name || '';
  if (!filePath.includes('/images/')) return;
  if (filePath.endsWith('_thumb.jpg')) return;
  const bucket = admin.storage().bucket(object.bucket);
  const [file] = await bucket.file(filePath).download();
  const thumb = await sharp(file).resize(400).jpeg({quality: 70}).toBuffer();
  const dest = filePath.replace(/\.jpg$/i, '_thumb.jpg');
  await bucket.file(dest).save(thumb, {contentType: 'image/jpeg', public: true});
});

exports.submitRSVP = functions.https.onCall(async (data, context) => {
  if (!context.app) {
    throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  }
  async function verifyRecaptcha(token, reqContext) {
    try {
      const siteKey = (functions.config().recaptcha && functions.config().recaptcha.site_key) || process.env.RECAPTCHA_SITE_KEY || '';
      const apiKey = (functions.config().recaptcha && functions.config().recaptcha.api_key) || process.env.RECAPTCHA_API_KEY || '';
      const projectId = process.env.GCLOUD_PROJECT || (admin.app().options.projectId || '');
      if (!token || !siteKey || !apiKey || !projectId) return true; // skip if not configured
      const url = `https://recaptchaenterprise.googleapis.com/v1/projects/${projectId}/assessments?key=${apiKey}`;
      const body = {
        event: {
          token,
          siteKey,
          expectedAction: 'submit_rsvp',
          userAgent: reqContext?.userAgent || '',
          userIpAddress: reqContext?.ip || '',
        },
      };
      const resp = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });
      const json = await resp.json();
      const valid = json.tokenProperties && json.tokenProperties.valid;
      const score = (json.riskAnalysis && json.riskAnalysis.score) || 0;
      return !!valid && score >= 0.5;
    } catch (_) {
      return false;
    }
  }
  const cardId = data.cardId;
  const name = (data.name || '').toString().trim();
  const phone = (data.phone || '').toString().trim();
  const note = (data.note || '').toString().trim();
  const side = (data.side || 'bride').toString();
  const attending = !!data.attending;
  const guestsCount = Number(data.guestsCount || 1);
  const recaptchaToken = (data.recaptchaToken || '').toString();
  if (!cardId || !name) {
    throw new functions.https.HttpsError('invalid-argument', 'cardId and name required');
  }
  const ok = await verifyRecaptcha(recaptchaToken, { userAgent: context.rawRequest?.headers['user-agent'], ip: context.rawRequest?.ip });
  if (!ok) {
    throw new functions.https.HttpsError('failed-precondition', 'reCAPTCHA verification failed');
  }
  const db = admin.firestore();
  const id = Date.now().toString();
  await db.collection('cards').doc(cardId).collection('guests').doc(id).set({
    guestId: id,
    name,
    phone,
    note,
    side,
    invited: side === 'bride',
    attended,
    guestsCount,
    giftAmount: 0,
    createdAt: new Date().toISOString(),
  });
  return {ok: true};
});

exports.initTotpEnrollment = functions.https.onCall(async (data, context) => {
  if (!context.app) {
    throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  }
  const uid = context.auth?.uid || '';
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login required');
  const secret = speakeasy.generateSecret({length: 20});
  const issuer = (functions.config().totp && functions.config().totp.issuer) || 'OnlineWedding';
  const label = `${issuer}:${uid}`;
  const otpauth_url = speakeasy.otpauthURL({secret: secret.base32, label, issuer, encoding: 'base32'});
  const db = admin.firestore();
  await db.collection('users').doc(uid).collection('security').doc('totp').set({ tempSecret: secret.base32, createdAt: new Date().toISOString() }, {merge: true});
  return {otpauthUrl: otpauth_url, secret: secret.base32};
});

exports.verifyTotpEnrollment = functions.https.onCall(async (data, context) => {
  if (!context.app) {
    throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  }
  const uid = context.auth?.uid || '';
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login required');
  const code = String(data.code || '');
  if (!code) throw new functions.https.HttpsError('invalid-argument', 'code required');
  const db = admin.firestore();
  const doc = await db.collection('users').doc(uid).collection('security').doc('totp').get();
  const m = doc.exists ? doc.data() : {};
  const secret = m.tempSecret || m.secret || '';
  if (!secret) throw new functions.https.HttpsError('failed-precondition', 'No temp secret');
  const ok = speakeasy.totp.verify({ secret, encoding: 'base32', token: code, window: 1 });
  if (!ok) throw new functions.https.HttpsError('failed-precondition', 'Invalid code');
  await db.collection('users').doc(uid).collection('security').doc('totp').set({ secret, tempSecret: admin.firestore.FieldValue.delete(), enabled: true, updatedAt: new Date().toISOString() }, {merge: true});
  return {ok: true};
});

exports.verifyTotpAndGrantMfa = functions.https.onCall(async (data, context) => {
  if (!context.app) {
    throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  }
  const uid = context.auth?.uid || '';
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login required');
  const code = String(data.code || '');
  if (!code) throw new functions.https.HttpsError('invalid-argument', 'code required');
  const db = admin.firestore();
  const doc = await db.collection('users').doc(uid).collection('security').doc('totp').get();
  const m = doc.exists ? doc.data() : {};
  const secret = m.secret || '';
  if (!secret || m.enabled !== true) throw new functions.https.HttpsError('failed-precondition', '2FA not enabled');
  const ok = speakeasy.totp.verify({ secret, encoding: 'base32', token: code, window: 1 });
  if (!ok) throw new functions.https.HttpsError('failed-precondition', 'Invalid code');
  const user = await admin.auth().getUser(uid);
  const claims = user.customClaims || {};
  claims.mfa = true;
  await admin.auth().setCustomUserClaims(uid, claims);
  return {ok: true};
});

exports.createCheckoutSession = functions.https.onCall(async (data, context) => {
  if (!context.app) {
    throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  }
  const uid = context.auth?.uid || '';
  if (!uid) {
    throw new functions.https.HttpsError('unauthenticated', 'Login required');
  }
  const planId = (data.planId || 'premium').toString();
  const db = admin.firestore();
  const invId = Date.now().toString();
  const planDoc = await db.collection('plans').doc(planId).get();
  const planData = planDoc.exists ? planDoc.data() : {};
  const amount = Number(planData.price || 0);
  const currency = String(planData.currency || 'usd');
  const priceId = String(planData.priceId || '');
  await db.collection('invoices').doc(invId).set({
    invoiceId: invId,
    ownerUid: uid,
    amount,
    note: `Checkout for plan ${planId}`,
    status: 'pending',
    transactionId: '',
    createdAt: new Date().toISOString(),
  });
  try {
    if (STRIPE_API_KEY) {
      const params = {
        mode: priceId ? 'subscription' : 'payment',
        line_items: priceId
          ? [{ price: priceId, quantity: 1 }]
          : [{
              price_data: {
                currency,
                product_data: { name: `Subscription ${planId}` },
                unit_amount: Math.max(0, Math.round(amount * 100)),
              },
              quantity: 1,
            }],
        success_url: `https://example.com/checkout-success?invoice=${encodeURIComponent(invId)}`,
        cancel_url: `https://example.com/checkout-cancel?invoice=${encodeURIComponent(invId)}`,
        metadata: { uid, invoiceId: invId, planId },
      };
      const session = await stripe.checkout.sessions.create(params);
      return {sessionUrl: session.url};
    }
  } catch (_) {}
  const sessionUrl = `https://example.com/checkout?plan=${encodeURIComponent(planId)}&uid=${encodeURIComponent(uid)}&invoice=${encodeURIComponent(invId)}`;
  return {sessionUrl};
});

exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
  try {
    const sig = req.headers['stripe-signature'];
    const secret = (functions.config().stripe && functions.config().stripe.webhook_secret) || process.env.STRIPE_WEBHOOK_SECRET || '';
    if (!sig || !secret) {
      return res.status(400).json({error: 'missing signature or secret'});
    }
    let event;
    try {
      event = stripe.webhooks.constructEvent(req.rawBody, sig, secret);
    } catch (err) {
      return res.status(400).json({error: 'invalid signature'});
    }
    const obj = event.data && event.data.object ? event.data.object : {};
    const uid = String((obj.metadata && obj.metadata.uid) || req.body.uid || '');
    const invoiceId = String((obj.metadata && obj.metadata.invoiceId) || req.body.invoiceId || '');
    const planId = String((obj.metadata && obj.metadata.planId) || req.body.planId || 'premium');
    const amount = Number(obj.amount_total || obj.amount || req.body.amount || 0);
    const transactionId = String(obj.id || req.body.transactionId || '');
    const status = String(event.type === 'checkout.session.completed' || event.type === 'payment_intent.succeeded' ? 'succeeded' : (req.body.status || 'succeeded'));
    const db = admin.firestore();
    if (invoiceId) {
      await db.collection('invoices').doc(invoiceId).set({
        invoiceId,
        ownerUid: uid,
        amount,
        note: 'Stripe payment',
        status,
        transactionId,
        createdAt: new Date().toISOString(),
      }, {merge: true});
    }
    if (uid && status === 'succeeded') {
      const now = new Date();
      const periodEnd = new Date(now);
      periodEnd.setMonth(periodEnd.getMonth() + 1);
      await db.collection('subscriptions').doc(uid).set({
        planId,
        updatedAt: now.toISOString(),
        currentPeriodEnd: periodEnd.toISOString(),
      }, {merge: true});
    }
    res.json({ok: true});
  } catch (e) {
    res.status(500).json({error: String(e)});
  }
});

exports.payosWebhook = functions.https.onRequest(async (req, res) => {
  try {
    const secret = (functions.config().payos && functions.config().payos.hmac_secret) || process.env.PAYOS_HMAC_SECRET || '';
    const headerSig = req.headers['x-callback-signature'] || req.headers['x-signature'] || '';
    if (!secret || !headerSig) {
      return res.status(400).json({error: 'missing signature or secret'});
    }
    const computed = crypto.createHmac('sha256', secret).update(req.rawBody).digest('hex');
    if (computed !== headerSig) {
      return res.status(400).json({error: 'invalid signature'});
    }
    const body = req.body || {};
    const uid = String(body.uid || '');
    const invoiceId = String(body.invoiceId || '');
    const status = String(body.status || 'PAID');
    const transactionId = String(body.transactionId || '');
    const planId = String(body.planId || 'premium');
    const amount = Number(body.amount || 0);
    const db = admin.firestore();
    if (invoiceId) {
      await db.collection('invoices').doc(invoiceId).set({
        invoiceId,
        ownerUid: uid,
        amount,
        note: 'PayOS payment',
        status,
        transactionId,
        createdAt: new Date().toISOString(),
      }, {merge: true});
    }
    if (uid && (status === 'PAID' || status === 'SUCCESS')) {
      const now = new Date();
      const periodEnd = new Date(now);
      periodEnd.setMonth(periodEnd.getMonth() + 1);
      await db.collection('subscriptions').doc(uid).set({
        planId,
        updatedAt: now.toISOString(),
        currentPeriodEnd: periodEnd.toISOString(),
      }, {merge: true});
    }
    res.json({ok: true});
  } catch (e) {
    res.status(500).json({error: String(e)});
  }
});
exports.seedPlans = functions.https.onCall(async (data, context) => {
  if (!context.app) {
    throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  }
  if (!context.auth || !context.auth.token || context.auth.token.admin !== true) {
    throw new functions.https.HttpsError('permission-denied', 'Admin only');
  }
  const items = Array.isArray(data?.items) ? data.items : [];
  if (items.length === 0) {
    throw new functions.https.HttpsError('invalid-argument', 'items required');
  }
  const db = admin.firestore();
  const batch = db.batch();
  for (const it of items) {
    const id = String(it.planId || '');
    if (!id) continue;
    const ref = db.collection('plans').doc(id);
    batch.set(ref, {
      name: String(it.name || id),
      price: Number(it.price || 0),
      period: String(it.period || 'monthly'),
      currency: String(it.currency || 'usd'),
      priceId: it.priceId ? String(it.priceId) : undefined,
    }, {merge: true});
  }
  await batch.commit();
  return {ok: true};
});
exports.setAdminClaim = functions.https.onCall(async (data, context) => {
  if (!context.app) {
    throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  }
  if (!context.auth || !context.auth.token || context.auth.token.admin !== true) {
    throw new functions.https.HttpsError('permission-denied', 'Admin only');
  }
  const uid = String(data.uid || '');
  const set = !!data.set;
  if (!uid) {
    throw new functions.https.HttpsError('invalid-argument', 'uid required');
  }
  const user = await admin.auth().getUser(uid);
  const current = user.customClaims || {};
  current.admin = set;
  await admin.auth().setCustomUserClaims(uid, current);
  return {ok: true, uid, admin: set};
});
const {
  generateRegistrationOptions,
  verifyRegistrationResponse,
  generateAuthenticationOptions,
  verifyAuthenticationResponse,
} = require('@simplewebauthn/server');
const RP_ID = (functions.config().webauthn && functions.config().webauthn.rp_id) || process.env.WEBAUTHN_RP_ID || 'localhost';
exports.startWebAuthnRegistration = functions.https.onCall(async (data, context) => {
  if (!context.app) throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  const uid = context.auth?.uid || '';
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login required');
  const db = admin.firestore();
  const credsSnap = await db.collection('users').doc(uid).collection('security').doc('webauthn').get();
  const creds = credsSnap.exists ? (credsSnap.data().credentials || []) : [];
  const options = generateRegistrationOptions({
    rpName: 'Online Wedding',
    rpID: RP_ID,
    userID: uid,
    userName: uid,
    attestationType: 'none',
    excludeCredentials: creds.map(c => ({ id: Buffer.from(c.id, 'base64url'), type: 'public-key' })),
  });
  await db.collection('users').doc(uid).collection('security').doc('webauthn').set({ currentChallenge: options.challenge, updatedAt: new Date().toISOString() }, {merge: true});
  return options;
});

exports.verifyWebAuthnRegistration = functions.https.onCall(async (data, context) => {
  if (!context.app) throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  const uid = context.auth?.uid || '';
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login required');
  const db = admin.firestore();
  const doc = await db.collection('users').doc(uid).collection('security').doc('webauthn').get();
  const m = doc.exists ? doc.data() : {};
  const expectedChallenge = m.currentChallenge || '';
  const verification = await verifyRegistrationResponse({
    response: data,
    expectedChallenge,
    expectedOrigin: `https://${RP_ID}`,
    expectedRPID: RP_ID,
  });
  if (!verification.verified) throw new functions.https.HttpsError('failed-precondition', 'Registration failed');
  const { credentialID, credentialPublicKey, counter } = verification.registrationInfo;
  const cred = {
    id: Buffer.from(credentialID).toString('base64url'),
    publicKey: Buffer.from(credentialPublicKey).toString('base64url'),
    counter,
  };
  const credsSnap = await db.collection('users').doc(uid).collection('security').doc('webauthn').get();
  const list = credsSnap.exists ? (credsSnap.data().credentials || []) : [];
  list.push(cred);
  await db.collection('users').doc(uid).collection('security').doc('webauthn').set({ credentials: list, currentChallenge: admin.firestore.FieldValue.delete(), enabled: true, updatedAt: new Date().toISOString() }, {merge: true});
  return {ok: true};
});

exports.startWebAuthnAuthentication = functions.https.onCall(async (data, context) => {
  if (!context.app) throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  const uid = context.auth?.uid || '';
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login required');
  const db = admin.firestore();
  const doc = await db.collection('users').doc(uid).collection('security').doc('webauthn').get();
  const m = doc.exists ? doc.data() : {};
  const creds = m.credentials || [];
  const options = generateAuthenticationOptions({
    rpID: RP_ID,
    allowCredentials: creds.map(c => ({ id: Buffer.from(c.id, 'base64url'), type: 'public-key' })),
    userVerification: 'required',
  });
  await db.collection('users').doc(uid).collection('security').doc('webauthn').set({ currentChallenge: options.challenge, updatedAt: new Date().toISOString() }, {merge: true});
  return options;
});

exports.verifyWebAuthnAuthentication = functions.https.onCall(async (data, context) => {
  if (!context.app) throw new functions.https.HttpsError('failed-precondition', 'AppCheck required');
  const uid = context.auth?.uid || '';
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login required');
  const db = admin.firestore();
  const doc = await db.collection('users').doc(uid).collection('security').doc('webauthn').get();
  const m = doc.exists ? doc.data() : {};
  const expectedChallenge = m.currentChallenge || '';
  const creds = m.credentials || [];
  const getCred = (id) => creds.find(c => c.id === id);
  const verification = await verifyAuthenticationResponse({
    response: data,
    expectedChallenge,
    expectedOrigin: `https://${RP_ID}`,
    expectedRPID: RP_ID,
    requireUserVerification: true,
    authenticator: (() => {
      const id = data.rawId || data.id;
      const cred = getCred(id);
      if (!cred) throw new functions.https.HttpsError('failed-precondition', 'Unknown credential');
      return {
        credentialID: Buffer.from(cred.id, 'base64url'),
        credentialPublicKey: Buffer.from(cred.publicKey, 'base64url'),
        counter: cred.counter || 0,
      };
    })(),
  });
  if (!verification.verified) throw new functions.https.HttpsError('failed-precondition', 'Authentication failed');
  const newCounter = verification.authenticationInfo.newCounter || 0;
  const id = data.rawId || data.id;
  const idx = creds.findIndex(c => c.id === id);
  if (idx >= 0) creds[idx].counter = newCounter;
  await db.collection('users').doc(uid).collection('security').doc('webauthn').set({ credentials: creds, currentChallenge: admin.firestore.FieldValue.delete(), lastAuthOkAt: new Date().toISOString() }, {merge: true});
  return {ok: true};
});
