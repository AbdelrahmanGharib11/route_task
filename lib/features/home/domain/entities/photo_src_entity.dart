import 'package:equatable/equatable.dart';

class PhotoSrcEntity extends Equatable {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  const PhotoSrcEntity({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  @override
  List<Object> get props => [
    original,
    large2x,
    large,
    medium,
    small,
    portrait,
    landscape,
    tiny,
  ];
}
