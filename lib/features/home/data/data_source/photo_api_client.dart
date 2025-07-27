import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:selfdep/features/home/data/models/photo/photo_model.dart';

part 'photo_api_client.g.dart';

@RestApi(baseUrl: 'https://api.pexels.com/v1/')
abstract class PhotoApiClient {
  factory PhotoApiClient(Dio dio, {String baseUrl}) = _PhotoApiClient;

  // Get curated photos
  @GET('/curated')
  Future<PhotosResponse> getCuratedPhotos({
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
  });

  // Search photos
  @GET('/search')
  Future<SearchPhotosResponse> searchPhotos({
    @Query('query') required String query,
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
    @Query('orientation')
    String? orientation, // 'landscape', 'portrait', 'square'
    @Query('size') String? size, // 'large', 'medium', 'small'
    @Query('color')
    String?
    color, // 'red', 'orange', 'yellow', 'green', 'turquoise', 'blue', 'violet', 'pink', 'brown', 'black', 'gray', 'white'
    @Query('locale')
    String?
    locale, // 'en-US', 'pt-BR', 'es-ES', 'ca-ES', 'de-DE', 'it-IT', 'fr-FR', 'sv-SE', 'id-ID', 'pl-PL', 'ja-JP', 'zh-TW', 'zh-CN', 'ko-KR', 'th-TH', 'nl-NL', 'hu-HU', 'vi-VN', 'cs-CZ', 'da-DK', 'fi-FI', 'uk-UA', 'el-GR', 'ro-RO', 'nb-NO', 'sk-SK', 'tr-TR', 'ru-RU'
  });

  // Get photo by ID
  @GET('/photos/{id}')
  Future<Photo> getPhotoById(@Path('id') int id);

  // Get popular photos (similar to curated but different endpoint)
  @GET('/popular')
  Future<PhotosResponse> getPopularPhotos({
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
  });
}
