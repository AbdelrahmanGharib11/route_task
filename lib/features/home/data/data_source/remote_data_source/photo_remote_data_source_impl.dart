import 'package:dio/dio.dart';
import 'package:selfdep/core/exceptions/exceptions_for_data_source.dart';
import 'package:selfdep/features/home/data/data_source/retrofit/photo_api_client.dart';
import 'package:selfdep/features/home/data/data_source/remote_data_source/photo_remote_data_source.dart';
import 'package:selfdep/features/home/data/models/photo/photo_model.dart';

class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource {
  final PhotoApiClient _apiClient;

  PhotoRemoteDataSourceImpl(Dio dio) : _apiClient = PhotoApiClient(dio);

  @override
  Future<PhotosResponse> getCuratedPhotos({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      return await _apiClient.getCuratedPhotos(page: page, perPage: perPage);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.cancel:
        return RequestCancelledException('Request was cancelled.');
      case DioExceptionType.unknown:
        return NetworkException(
          'Network error. Please check your internet connection.',
        );
      default:
        return UnknownException('An unknown error occurred.');
    }
  }
}
