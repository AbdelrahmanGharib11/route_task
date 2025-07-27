import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'photoAppCache';
  static CustomCacheManager? instance;

  factory CustomCacheManager() {
    return instance ??= CustomCacheManager._();
  }

  CustomCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 500,
          repo: JsonCacheInfoRepository(databaseName: key),
        ),
      );
}
