import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selfdep/features/home/domain/entities/photo_entity.dart';
import 'package:selfdep/features/home/domain/entities/photo_src_entity.dart';
import 'package:selfdep/features/home/domain/usecases/get_photos.dart';
import 'package:selfdep/features/home/presentation/cubit/photo_states.dart';
import 'package:selfdep/features/home/data/data_source/local_data_source/photo_local_data_source.dart';
import 'package:selfdep/core/di/service_locator.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final GetCuratedPhotos _getCuratedPhotos;

  PhotoCubit({required GetCuratedPhotos getCuratedPhotos})
    : _getCuratedPhotos = getCuratedPhotos,
      super(PhotoInitial());

  Future<void> getCuratedPhotos({
    int page = 1,
    int perPage = 20,
    bool isRefresh = false,
  }) async {
    try {
      if (isRefresh) {
        emit(PhotoLoading());
      } else if (state is! PhotoLoaded) {
        emit(PhotoLoading());
      } else {
        final currentState = state as PhotoLoaded;
        emit(PhotoLoadingMore(currentState.photos));
      }

      final photos = await _getCuratedPhotos(page: page, perPage: perPage);

      if (isRefresh || state is PhotoLoading) {
        emit(
          PhotoLoaded(
            photos: photos,
            currentPage: page,
            hasReachedMax: photos.length < perPage,
          ),
        );
      } else {
        final currentState = state;
        if (currentState is PhotoLoaded) {
          emit(
            currentState.copyWith(
              photos: [...currentState.photos, ...photos],
              currentPage: page,
              hasReachedMax: photos.length < perPage,
            ),
          );
        } else if (currentState is PhotoLoadingMore) {
          emit(
            PhotoLoaded(
              photos: [...currentState.photos, ...photos],
              currentPage: page,
              hasReachedMax: photos.length < perPage,
            ),
          );
        }
      }
    } catch (e) {
      final currentState = state;
      if (currentState is PhotoLoaded &&
          currentState.photos.isNotEmpty &&
          !isRefresh) {
        emit(
          PhotoErrorWithCache(
            photos: currentState.photos,
            message: _getErrorMessage(e),
            currentPage: currentState.currentPage,
          ),
        );
      } else {
        emit(PhotoError(_getErrorMessage(e)));
      }
    }
  }

  Future<void> loadMorePhotos() async {
    final currentState = state;
    if (currentState is PhotoLoaded && !currentState.hasReachedMax) {
      final nextPage = currentState.currentPage + 1;
      await getCuratedPhotos(page: nextPage);
    }
  }

  void refresh() {
    final currentState = state;
    if (currentState is PhotoLoaded) {
      getCuratedPhotos(isRefresh: true);
    } else {
      getCuratedPhotos();
    }
  }

  void clearPhotos() {
    emit(PhotoInitial());
  }

  String _getErrorMessage(Object error) {
    if (error.toString().contains('NetworkException')) {
      return 'Please check your internet connection';
    } else if (error.toString().contains('UnauthorizedException')) {
      return 'API key is invalid. Please check your configuration';
    } else if (error.toString().contains('RateLimitException')) {
      return 'API rate limit exceeded. Please try again later';
    } else if (error.toString().contains('ServerException')) {
      return 'Server error. Please try again later';
    } else {
      return 'Something went wrong. Please try again';
    }
  }

  Future<void> initializePhotos() async {
    emit(PhotoLoading());

    try {
      final cachedPhotos = await _getCachedPhotos();
      if (cachedPhotos.isNotEmpty) {
        emit(
          PhotoLoaded(
            photos: cachedPhotos,
            currentPage: 1,
            hasReachedMax: false,
          ),
        );
        _refreshInBackground();
        return;
      }
      await getCuratedPhotos();
    } catch (e) {
      emit(PhotoError(_getErrorMessage(e)));
    }
  }

  Future<void> _refreshInBackground() async {
    try {
      final photos = await _getCuratedPhotos(page: 1, perPage: 40);
      emit(
        PhotoLoaded(
          photos: photos,
          currentPage: 1,
          hasReachedMax: photos.length < 40,
        ),
      );
    } catch (e) {}
  }

  Future<List<PhotoEntity>> _getCachedPhotos({int page = 1}) async {
    try {
      final localDataSource = sl<PhotoLocalDataSource>();
      final cachedPhotos = await localDataSource.getCachedPhotos(page: page);

      return cachedPhotos
          .map(
            (photo) => PhotoEntity(
              id: photo.id,
              width: photo.width,
              height: photo.height,
              url: photo.url,
              photographer: photo.photographer,
              photographerUrl: photo.photographerUrl,
              photographerId: photo.photographerId,
              avgColor: photo.avgColor,
              src: PhotoSrcEntity(
                original: photo.src.original,
                large2x: photo.src.large2x,
                large: photo.src.large,
                medium: photo.src.medium,
                small: photo.src.small,
                portrait: photo.src.portrait,
                landscape: photo.src.landscape,
                tiny: photo.src.tiny,
              ),
              liked: photo.liked,
              alt: photo.alt,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }
}
