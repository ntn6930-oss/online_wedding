const admin = require('firebase-admin');
admin.initializeApp();

async function main() {
  const db = admin.firestore();
  const items = [
    { planId: 'free', name: 'Free', price: 0, period: 'monthly', currency: 'usd' },
    { planId: 'basic', name: 'Basic', price: 5.0, period: 'monthly', currency: 'usd' },
    { planId: 'premium', name: 'Premium', price: 15.0, period: 'monthly', currency: 'usd' },
  ];
  const batch = db.batch();
  for (const it of items) {
    const ref = db.collection('plans').doc(it.planId);
    batch.set(ref, {
      name: it.name,
      price: it.price,
      period: it.period,
      currency: it.currency,
      // priceId left empty for manual fill later
    }, { merge: true });
  }
  await batch.commit();
  console.log('Seeded plans:', items.map(i => i.planId).join(', '));
  process.exit(0);
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});

