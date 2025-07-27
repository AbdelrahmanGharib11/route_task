import '../entities/photo_entity.dart';

abstract class PhotoRepository {
  Future<List<PhotoEntity>> getCuratedPhotos({int page = 1, int perPage = 20});
}
