import 'package:hive/hive.dart';
import 'package:selfdep/features/home/data/models/photo/photo_model.dart';

part 'photo_hive_model.g.dart';

@HiveType(typeId: 0)
class PhotoHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int width;

  @HiveField(2)
  final int height;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String photographer;

  @HiveField(5)
  final String photographerUrl;

  @HiveField(6)
  final int photographerId;

  @HiveField(7)
  final String avgColor;

  @HiveField(8)
  final PhotoSrcHiveModel src;

  @HiveField(9)
  final bool liked;

  @HiveField(10)
  final String alt;

  PhotoHiveModel({
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

  factory PhotoHiveModel.fromPhoto(Photo photo) {
    return PhotoHiveModel(
      id: photo.id,
      width: photo.width,
      height: photo.height,
      url: photo.url,
      photographer: photo.photographer,
      photographerUrl: photo.photographerUrl,
      photographerId: photo.photographerId,
      avgColor: photo.avgColor,
      src: PhotoSrcHiveModel.fromPhotoSrc(photo.src),
      liked: photo.liked,
      alt: photo.alt,
    );
  }

  Photo toPhoto() {
    return Photo(
      id: id,
      width: width,
      height: height,
      url: url,
      photographer: photographer,
      photographerUrl: photographerUrl,
      photographerId: photographerId,
      avgColor: avgColor,
      src: src.toPhotoSrc(),
      liked: liked,
      alt: alt,
    );
  }
}

@HiveType(typeId: 1)
class PhotoSrcHiveModel {
  @HiveField(0)
  final String original;

  @HiveField(1)
  final String large2x;

  @HiveField(2)
  final String large;

  @HiveField(3)
  final String medium;

  @HiveField(4)
  final String small;

  @HiveField(5)
  final String portrait;

  @HiveField(6)
  final String landscape;

  @HiveField(7)
  final String tiny;

  PhotoSrcHiveModel({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory PhotoSrcHiveModel.fromPhotoSrc(PhotoSrc src) {
    return PhotoSrcHiveModel(
      original: src.original,
      large2x: src.large2x,
      large: src.large,
      medium: src.medium,
      small: src.small,
      portrait: src.portrait,
      landscape: src.landscape,
      tiny: src.tiny,
    );
  }

  PhotoSrc toPhotoSrc() {
    return PhotoSrc(
      original: original,
      large2x: large2x,
      large: large,
      medium: medium,
      small: small,
      portrait: portrait,
      landscape: landscape,
      tiny: tiny,
    );
  }
}
