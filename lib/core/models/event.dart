import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required String creatorUserId,
    required String regionId,
    required DateTime startDate,
    DateTime? endDate,
    required String description,
    String? imageUrl,
    String? sourceUrl,
    required int likesCount,
    required int dislikesCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
