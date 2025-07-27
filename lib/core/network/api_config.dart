import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ApiConfig {
  static const String baseUrl = 'https://api.pexels.com/v1/';
  static const String apiKey =
      'By3ySsf8OD9OZoJnS4e3vhvdA9oAIaK142hOBWzsaqW2pVkKayYWvrXz';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}

class DioClient {
  late Dio _dio;
  final Logger _logger = Logger();

  DioClient() {
    _dio = Dio();
    _configureDio();
    _addInterceptors();
  }

  Dio get dio => _dio;

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
      headers: {
        'Authorization': ApiConfig.apiKey,
        'Content-Type': 'application/json',
      },
    );
  }

  void _addInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _logger.w('⏰ Request timeout: ${error.message}');
        break;
      case DioExceptionType.badResponse:
        _logger.e(
          '❌ HTTP Error: ${error.response?.statusCode} - ${error.response?.statusMessage}',
        );
        _handleHttpError(error);
        break;
      case DioExceptionType.cancel:
        _logger.i('🚫 Request cancelled: ${error.message}');
        break;
      case DioExceptionType.unknown:
        _logger.e('🌐 Network error: ${error.message}');
        break;
      case DioExceptionType.connectionTimeout:
        _logger.w('🔌 Connection timeout: ${error.message}');
        break;
      case DioExceptionType.badCertificate:
        _logger.e('🔒 SSL Certificate error: ${error.message}');
        break;
      case DioExceptionType.connectionError:
        _logger.e('📡 Connection error: ${error.message}');
        break;
    }
  }

  void _handleHttpError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    switch (statusCode) {
      case 400:
        _logger.e('🔴 Bad Request (400): Invalid request parameters');
        break;
      case 401:
        _logger.e(
          '🔐 Unauthorized (401): Invalid API key or authentication failed',
        );
        break;
      case 403:
        _logger.e('🚫 Forbidden (403): Access denied to this resource');
        break;
      case 404:
        _logger.w('🔍 Not Found (404): Resource not found');
        break;
      case 429:
        _logger.w(
          '⏳ Rate Limited (429): Too many requests, please try again later',
        );
        break;
      case 500:
        _logger.e(
          '🔥 Internal Server Error (500): Server is experiencing issues',
        );
        break;
      case 502:
        _logger.e('🌐 Bad Gateway (502): Server received invalid response');
        break;
      case 503:
        _logger.w(
          '⚠️ Service Unavailable (503): Server is temporarily unavailable',
        );
        break;
      default:
        _logger.e(
          '❌ HTTP Error ($statusCode): ${error.response?.statusMessage}',
        );
        break;
    }

    if (responseData != null) {
      _logger.d('📄 Response data: $responseData');
    }
  }
}
