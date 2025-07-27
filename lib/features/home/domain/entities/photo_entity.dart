import 'package:equatable/equatable.dart';
import 'package:selfdep/features/home/domain/entities/photo_src_entity.dart';

class PhotoEntity extends Equatable {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final int photographerId;
  final String avgColor;
  final PhotoSrcEntity src;
  final bool liked;
  final String alt;

  const PhotoEntity({
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

  double get aspectRatio => height > 0 ? width / height : 1.0;

  @override
  List<Object> get props => [
    id,
    width,
    height,
    url,
    photographer,
    photographerUrl,
    photographerId,
    avgColor,
    src,
    liked,
    alt,
  ];
}
