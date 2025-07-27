import 'package:equatable/equatable.dart';
import 'package:selfdep/features/home/domain/entities/photo_entity.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object?> get props => [];
}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoadingMore extends PhotoState {
  final List<PhotoEntity> photos;

  const PhotoLoadingMore(this.photos);

  @override
  List<Object> get props => [photos];
}

class PhotoLoaded extends PhotoState {
  final List<PhotoEntity> photos;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentQuery;

  const PhotoLoaded({
    required this.photos,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.currentQuery,
  });

  PhotoLoaded copyWith({
    List<PhotoEntity>? photos,
    bool? hasReachedMax,
    int? currentPage,
    String? currentQuery,
  }) {
    return PhotoLoaded(
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }

  @override
  List<Object?> get props => [photos, hasReachedMax, currentPage, currentQuery];
}

class PhotoError extends PhotoState {
  final String message;

  const PhotoError(this.message);

  @override
  List<Object> get props => [message];
}

class PhotoErrorWithCache extends PhotoState {
  final List<PhotoEntity> photos;
  final String message;
  final int currentPage;

  const PhotoErrorWithCache({
    required this.photos,
    required this.message,
    this.currentPage = 1,
  });

  @override
  List<Object> get props => [photos, message, currentPage];
}
