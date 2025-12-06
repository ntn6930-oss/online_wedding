import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_wedding/features/e_card/data/datasources/card_remote_data_source.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreCardRemoteDataSource implements CardRemoteDataSource {
  final FirebaseFirestore db;
  FirestoreCardRemoteDataSource(this.db);

  @override
  Future<WeddingCardEntity> createCard(CreateNewCardParams params) async {
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
    return qs.docs.map((d) {
      final m = d.data();
      return GuestModel(
        guestId: m['guestId'] as String,
        name: m['name'] as String,
        invited: m['invited'] as bool,
        attended: m['attended'] as bool,
        giftAmount: (m['giftAmount'] as num).toDouble(),
      );
    }).toList();
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
    final ref = FirebaseStorage.instance.ref().child('cards/$cardId/images/$fileName');
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
