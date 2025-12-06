import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'components/invitation_header.dart';
import 'components/guest_name_badge.dart';
import 'components/date_countdown.dart';
import 'components/venue_info_section.dart';
import 'components/venue_map_section.dart';
import 'components/album_section.dart';
import 'components/gift_box_section.dart';
import 'components/bride_groom_info_section.dart';
import 'components/family_info_section.dart';
import 'components/love_history_section.dart';
import 'components/rsvp_section.dart';

class WeddingTemplateWrapper extends ConsumerWidget {
  final WeddingCardEntity card;
  final CardCustomizationEntity? customization;
  final List<String> images;
  final String? guestName;
  final String? brideVenue;
  final String? groomVenue;
  final String? brideName;
  final String? groomName;
  final String? bridePhotoUrl;
  final String? groomPhotoUrl;
  final List<String> brideFamily;
  final List<String> groomFamily;
  final List<LoveEvent> loveTimeline;
  final bool enableRsvp;
  const WeddingTemplateWrapper({
    super.key,
    required this.card,
    this.customization,
    this.images = const [],
    this.guestName,
    this.brideVenue,
    this.groomVenue,
    this.brideName,
    this.groomName,
    this.bridePhotoUrl,
    this.groomPhotoUrl,
    this.brideFamily = const [],
    this.groomFamily = const [],
    this.loveTimeline = const [],
    this.enableRsvp = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAlbum = customization?.showAlbum ?? false;
    final showMap = customization?.showMap ?? false;
    final showCountdown = customization?.showCountdown ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InvitationHeader(card: card, customization: customization),
        if (guestName != null && card.isPremium)
          GuestNameBadge(name: guestName!),
        BrideGroomInfoSection(
          brideName: brideName,
          groomName: groomName,
          bridePhotoUrl: bridePhotoUrl,
          groomPhotoUrl: groomPhotoUrl,
        ),
        if (showCountdown)
          DateCountdown(date: card.date),
        if (brideVenue != null || groomVenue != null)
          VenueInfoSection(
            brideVenue: brideVenue,
            groomVenue: groomVenue,
          ),
        if (card.isPremium && (brideFamily.isNotEmpty || groomFamily.isNotEmpty))
          FamilyInfoSection(brideFamily: brideFamily, groomFamily: groomFamily),
        if (showMap)
          VenueMapSection(query: card.coupleName),
        if (loveTimeline.isNotEmpty)
          LoveHistorySection(events: loveTimeline),
        if (showAlbum && images.isNotEmpty)
          AlbumSection(images: images),
        if (card.isPremium)
          GiftBoxSection(
            brideLabel: 'Cô dâu',
            groomLabel: 'Chú rể',
            brideData: '${card.coupleName} ${card.cardId} bride',
            groomData: '${card.coupleName} ${card.cardId} groom',
          ),
        if (card.isPremium && enableRsvp)
          RsvpSection(cardId: card.cardId),
      ],
    );
  }
}
