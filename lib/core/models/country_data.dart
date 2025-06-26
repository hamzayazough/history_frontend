import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_data.freezed.dart';
part 'country_data.g.dart';

@freezed
class CountryData with _$CountryData {
  const factory CountryData({
    required String id,
    required String name,
    required String code,
    required double latitude,
    required double longitude,
    required String continent,
    String? flagUrl,
    String? description,
  }) = _CountryData;

  factory CountryData.fromJson(Map<String, dynamic> json) =>
      _$CountryDataFromJson(json);
}
