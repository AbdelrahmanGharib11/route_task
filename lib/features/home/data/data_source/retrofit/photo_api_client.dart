import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:selfdep/features/home/data/models/photo/photo_model.dart';

part 'photo_api_client.g.dart';

@RestApi(baseUrl: 'https://api.pexels.com/v1/')
abstract class PhotoApiClient {
  factory PhotoApiClient(Dio dio, {String baseUrl}) = _PhotoApiClient;

  @GET('/curated')
  Future<PhotosResponse> getCuratedPhotos({
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
  });
}
