import '../../models/photo/photo_model.dart';

abstract class PhotoRemoteDataSource {
  Future<PhotosResponse> getCuratedPhotos({int page = 1, int perPage = 20});
}
