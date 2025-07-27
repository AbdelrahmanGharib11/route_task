import 'package:json_annotation/json_annotation.dart';

part 'photo_model.g.dart';

@JsonSerializable()
class PhotoSrc {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  PhotoSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory PhotoSrc.fromJson(Map<String, dynamic> json) =>
      _$PhotoSrcFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoSrcToJson(this);
}

@JsonSerializable()
class Photo {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  @JsonKey(name: 'photographer_url')
  final String photographerUrl;
  @JsonKey(name: 'photographer_id')
  final int photographerId;
  @JsonKey(name: 'avg_color')
  final String avgColor;
  final PhotoSrc src;
  final bool liked;
  final String alt;

  Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.liked,
    required this.alt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  String get originalImage => src.original;
  String get largeImage => src.large;
  String get mediumImage => src.medium;
  String get smallImage => src.small;
  String get portraitImage => src.portrait;
  String get landscapeImage => src.landscape;
  String get tinyImage => src.tiny;

  double get aspectRatio {
    if (height > 0) {
      return width / height;
    }
    return 1.0;
  }
}

@JsonSerializable()
class PhotosResponse {
  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;
  final List<Photo> photos;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'next_page')
  final String? nextPage;

  PhotosResponse({
    required this.page,
    required this.perPage,
    required this.photos,
    required this.totalResults,
    this.nextPage,
  });

  factory PhotosResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotosResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PhotosResponseToJson(this);
}

@JsonSerializable()
class SearchPhotosResponse {
  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;
  final List<Photo> photos;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'next_page')
  final String? nextPage;

  SearchPhotosResponse({
    required this.page,
    required this.perPage,
    required this.photos,
    required this.totalResults,
    this.nextPage,
  });

  factory SearchPhotosResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchPhotosResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchPhotosResponseToJson(this);
}
