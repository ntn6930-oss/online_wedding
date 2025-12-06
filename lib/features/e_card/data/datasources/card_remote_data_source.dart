import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';

abstract class CardRemoteDataSource {
  Future<WeddingCardEntity> createCard(CreateNewCardParams params);
  Future<WeddingCardEntity?> getCardById(String cardId);
  Future<List<WeddingCardEntity>> listCardsByOwner(String ownerUid);
  Future<List<WeddingCardEntity>> listCardsByOwnerPaged(
    String ownerUid,
    int limit,
    DateTime? startAfterDate,
  );
  Future<void> registerSlug(String slug, String cardId);
  Future<String?> getCardIdBySlug(String slug);
  Future<void> addGuest(String cardId, GuestModel guest);
  Future<List<GuestModel>> listGuests(String cardId);
  Future<List<GuestModel>> listGuestsPaged(
    String cardId,
    int limit,
    String? startAfterGuestId,
  );
  Future<void> setPublic(String cardId, bool isPublic);
  Future<bool> isPublic(String cardId);
  Future<void> setCustomization(String cardId, Map<String, dynamic> customization);
  Future<Map<String, dynamic>?> getCustomization(String cardId);
  Future<String> uploadImage(String cardId, String fileName, List<int> bytes);
  Future<List<String>> listImages(String cardId);
}

class GuestModel {
  final String guestId;
  final String name;
  final bool invited;
  final bool attended;
  final double giftAmount;
  GuestModel({
    required this.guestId,
    required this.name,
    required this.invited,
    required this.attended,
    required this.giftAmount,
  });
}

class InMemoryCardRemoteDataSource implements CardRemoteDataSource {
  final Map<String, WeddingCardEntity> _cards = {};
  final Map<String, String> _slugToCard = {};
  final Map<String, List<GuestModel>> _guests = {};
  final Map<String, bool> _public = {};
  final Map<String, Map<String, dynamic>> _custom = {};
  final Map<String, List<String>> _images = {};
  final Map<String, String> _ownerOf = {};

  @override
  Future<WeddingCardEntity> createCard(CreateNewCardParams params) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final card = WeddingCardEntity(
      cardId: id,
      templateId: params.templateId,
      coupleName: params.coupleName,
      date: params.date,
      storageUrl: 'https://example.com/cards/$id.png',
      isPremium: params.isPremium,
    );
    _cards[id] = card;
    _ownerOf[id] = 'mock';
    return card;
  }

  @override
  Future<WeddingCardEntity?> getCardById(String cardId) async {
    return _cards[cardId];
  }

  @override
  Future<List<WeddingCardEntity>> listCardsByOwner(String ownerUid) async {
    return _cards.values.toList();
  }

  @override
  Future<List<WeddingCardEntity>> listCardsByOwnerPaged(
    String ownerUid,
    int limit,
    DateTime? startAfterDate,
  ) async {
    final all = _cards.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    Iterable<WeddingCardEntity> it = all;
    if (startAfterDate != null) {
      it = it.where((e) => e.date.isAfter(startAfterDate));
    }
    return it.take(limit).toList();
  }

  @override
  Future<void> registerSlug(String slug, String cardId) async {
    _slugToCard[slug] = cardId;
  }

  @override
  Future<String?> getCardIdBySlug(String slug) async {
    return _slugToCard[slug];
  }

  @override
  Future<void> addGuest(String cardId, GuestModel guest) async {
    final list = _guests.putIfAbsent(cardId, () => []);
    list.add(guest);
  }

  @override
  Future<List<GuestModel>> listGuests(String cardId) async {
    return List.unmodifiable(_guests[cardId] ?? []);
  }

  @override
  Future<List<GuestModel>> listGuestsPaged(
    String cardId,
    int limit,
    String? startAfterGuestId,
  ) async {
    final list = List<GuestModel>.from(_guests[cardId] ?? []);
    list.sort((a, b) => a.guestId.compareTo(b.guestId));
    Iterable<GuestModel> it = list;
    if (startAfterGuestId != null) {
      it = it.where((e) => e.guestId.compareTo(startAfterGuestId) > 0);
    }
    return it.take(limit).toList();
  }

  @override
  Future<void> setPublic(String cardId, bool isPublic) async {
    _public[cardId] = isPublic;
  }

  @override
  Future<bool> isPublic(String cardId) async {
    return _public[cardId] ?? false;
  }

  @override
  Future<void> setCustomization(String cardId, Map<String, dynamic> customization) async {
    _custom[cardId] = customization;
  }

  @override
  Future<Map<String, dynamic>?> getCustomization(String cardId) async {
    return _custom[cardId];
  }

  @override
  Future<String> uploadImage(String cardId, String fileName, List<int> bytes) async {
    final url = 'https://example.com/cards/$cardId/images/$fileName';
    final list = _images.putIfAbsent(cardId, () => []);
    list.add(url);
    return url;
  }

  @override
  Future<List<String>> listImages(String cardId) async {
    return List.unmodifiable(_images[cardId] ?? []);
  }
}
