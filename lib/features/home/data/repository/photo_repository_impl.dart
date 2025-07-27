import 'package:selfdep/features/home/data/data_source/local_data_source/photo_local_data_source.dart';
import 'package:selfdep/features/home/data/data_source/remote_data_source/photo_remote_data_source.dart';
import 'package:selfdep/features/home/data/models/photo/photo_model.dart';
import 'package:selfdep/features/home/domain/entities/photo_src_entity.dart';
import 'package:selfdep/features/home/domain/repository/photo_repository.dart';
import '../../domain/entities/photo_entity.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource _remoteDataSource;
  final PhotoLocalDataSource _localDataSource;

  PhotoRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<PhotoEntity>> getCuratedPhotos({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final result = await _remoteDataSource.getCuratedPhotos(
        page: page,
        perPage: perPage,
      );

      await _localDataSource.cachePhotos(result.photos, page: page);

      return result.photos.map((photo) => _mapToEntity(photo)).toList();
    } catch (e) {
      final cachedPhotos = await _localDataSource.getCachedPhotos(page: page);
      if (cachedPhotos.isNotEmpty) {
        return cachedPhotos.map((photo) => _mapToEntity(photo)).toList();
      }
      rethrow;
    }
  }

  PhotoEntity _mapToEntity(Photo photo) {
    return PhotoEntity(
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
    );
  }
}
