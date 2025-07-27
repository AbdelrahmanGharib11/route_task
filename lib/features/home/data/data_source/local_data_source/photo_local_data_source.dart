import '../../models/photo/photo_model.dart';

abstract class PhotoLocalDataSource {
  Future<void> cachePhotos(List<Photo> photos, {String? query, int page = 1});
  Future<List<Photo>> getCachedPhotos({String? query, int page = 1});
  Future<void> clearCache({String? query});
  Future<bool> hasCachedPhotos({String? query, int page = 1});
}
