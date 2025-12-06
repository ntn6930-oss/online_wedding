import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_wedding/features/e_card/data/datasources/card_remote_data_source.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreCardRemoteDataSource implements CardRemoteDataSource {
  final FirebaseFirestore db;
  FirestoreCardRemoteDataSource(this.db);

  @override
  Future<WeddingCardEntity> createCard(CreateNewCardParams params) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception('AUTH_REQUIRED');
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final data = {
      'cardId': id,
      'templateId': params.templateId,
      'coupleName': params.coupleName,
      'date': params.date.toIso8601String(),
      'storageUrl': '',
      'isPremium': params.isPremium,
      'isPublic': false,
      'customization': {},
      'images': [],
      'ownerUid': uid,
    };
    await db.collection('cards').doc(id).set(data);
    return WeddingCardEntity(
      cardId: id,
      templateId: params.templateId,
      coupleName: params.coupleName,
      date: params.date,
      storageUrl: '',
      isPremium: params.isPremium,
    );
  }

  @override
  Future<WeddingCardEntity?> getCardById(String cardId) async {
    final doc = await db.collection('cards').doc(cardId).get();
    if (!doc.exists) return null;
    final m = doc.data()!;
    return WeddingCardEntity(
      cardId: m['cardId'] as String,
      templateId: m['templateId'] as String,
      coupleName: m['coupleName'] as String,
      date: DateTime.parse(m['date'] as String),
      storageUrl: m['storageUrl'] as String,
      isPremium: m['isPremium'] as bool,
    );
  }

  @override
  Future<List<WeddingCardEntity>> listCardsByOwner(String ownerUid) async {
    final qs = await db.collection('cards').where('ownerUid', isEqualTo: ownerUid).get();
    return qs.docs
        .map((d) {
          final m = d.data();
          final dateStr = (m['date'] as String?) ?? DateTime.now().toIso8601String();
          return WeddingCardEntity(
            cardId: (m['cardId'] as String?) ?? d.id,
            templateId: (m['templateId'] as String?) ?? '',
            coupleName: (m['coupleName'] as String?) ?? '',
            date: DateTime.tryParse(dateStr) ?? DateTime.now(),
            storageUrl: (m['storageUrl'] as String?) ?? '',
            isPremium: (m['isPremium'] as bool?) ?? false,
          );
        })
        .whereType<WeddingCardEntity>()
        .toList();
  }

  @override
  Future<List<WeddingCardEntity>> listCardsByOwnerPaged(
    String ownerUid,
    int limit,
    DateTime? startAfterDate,
  ) async {
    Query q = db
        .collection('cards')
        .where('ownerUid', isEqualTo: ownerUid)
        .orderBy('date')
        .limit(limit);
    if (startAfterDate != null) {
      q = q.startAfter([startAfterDate.toIso8601String()]);
    }
    final qs = await q.get();
    return qs.docs
        .map((d) {
          final m = d.data();
          if (m == null) return null;
          final dateStr = ((m as Map<String, dynamic>)['date'] as String?) ?? DateTime.now().toIso8601String();
          return WeddingCardEntity(
            cardId: (m['cardId'] as String?) ?? d.id,
            templateId: (m['templateId'] as String?) ?? '',
            coupleName: (m['coupleName'] as String?) ?? '',
            date: DateTime.tryParse(dateStr) ?? DateTime.now(),
            storageUrl: (m['storageUrl'] as String?) ?? '',
            isPremium: (m['isPremium'] as bool?) ?? false,
          );
        })
        .whereType<WeddingCardEntity>()
        .toList();
  }

  @override
  Future<void> registerSlug(String slug, String cardId) async {
    await db.collection('slugs').doc(slug).set({'cardId': cardId});
  }

  @override
  Future<String?> getCardIdBySlug(String slug) async {
    final doc = await db.collection('slugs').doc(slug).get();
    if (!doc.exists) return null;
    return (doc.data()!['cardId'] as String);
  }

  @override
  Future<void> addGuest(String cardId, GuestModel guest) async {
    await db
        .collection('cards')
        .doc(cardId)
        .collection('guests')
        .doc(guest.guestId)
        .set({
      'guestId': guest.guestId,
      'name': guest.name,
      'invited': guest.invited,
      'attended': guest.attended,
      'giftAmount': guest.giftAmount,
    });
  }

  @override
  Future<List<GuestModel>> listGuests(String cardId) async {
    final qs = await db.collection('cards').doc(cardId).collection('guests').get();
    return qs.docs
        .map((d) {
          final m = d.data();
          return GuestModel(
            guestId: (m['guestId'] as String?) ?? d.id,
            name: (m['name'] as String?) ?? '',
            invited: (m['invited'] as bool?) ?? false,
            attended: (m['attended'] as bool?) ?? false,
            giftAmount: ((m['giftAmount'] as num?) ?? 0).toDouble(),
          );
        })
        .whereType<GuestModel>()
        .toList();
  }

  @override
  Future<List<GuestModel>> listGuestsPaged(
    String cardId,
    int limit,
    String? startAfterGuestId,
  ) async {
    Query q = db
        .collection('cards')
        .doc(cardId)
        .collection('guests')
        .orderBy('guestId')
        .limit(limit);
    if (startAfterGuestId != null) {
      q = q.startAfter([startAfterGuestId]);
    }
    final qs = await q.get();
    return qs.docs
        .map((d) {
          final m = d.data();
          if (m == null) return null;
          return GuestModel(
            guestId: ((m as Map<String, dynamic>)['guestId'] as String?) ?? d.id,
            name: (m['name'] as String?) ?? '',
            invited: (m['invited'] as bool?) ?? false,
            attended: (m['attended'] as bool?) ?? false,
            giftAmount: ((m['giftAmount'] as num?) ?? 0).toDouble(),
          );
        })
        .whereType<GuestModel>()
        .toList();
  }

  @override
  Future<void> setPublic(String cardId, bool isPublic) async {
    await db.collection('cards').doc(cardId).update({'isPublic': isPublic});
  }

  @override
  Future<bool> isPublic(String cardId) async {
    final doc = await db.collection('cards').doc(cardId).get();
    if (!doc.exists) return false;
    final m = doc.data()!;
    final v = m['isPublic'];
    if (v is bool) return v;
    return false;
  }

  @override
  Future<void> setCustomization(String cardId, Map<String, dynamic> customization) async {
    await db.collection('cards').doc(cardId).update({'customization': customization});
  }

  @override
  Future<Map<String, dynamic>?> getCustomization(String cardId) async {
    final doc = await db.collection('cards').doc(cardId).get();
    if (!doc.exists) return null;
    final m = doc.data()!;
    final c = m['customization'];
    if (c is Map<String, dynamic>) return c;
    return null;
  }

  @override
  Future<String> uploadImage(String cardId, String fileName, List<int> bytes) async {
    final doc = await db.collection('cards').doc(cardId).get();
    final m = doc.data() ?? {};
    final ownerUid = (m['ownerUid'] as String?) ?? 'unknown';
    final ref = FirebaseStorage.instance
        .ref()
        .child('users/$ownerUid/cards/$cardId/images/$fileName');
    await ref.putData(Uint8List.fromList(bytes));
    final url = await ref.getDownloadURL();
    await db.collection('cards').doc(cardId).update({
      'images': FieldValue.arrayUnion([url]),
    });
    return url;
  }

  @override
  Future<List<String>> listImages(String cardId) async {
    final doc = await db.collection('cards').doc(cardId).get();
    if (!doc.exists) return [];
    final m = doc.data()!;
    final imgs = m['images'];
    if (imgs is List) {
      return imgs.map((e) => e.toString()).toList();
    }
    return [];
  }
}
