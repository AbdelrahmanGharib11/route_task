import 'package:hive/hive.dart';
import 'package:selfdep/features/home/data/data_source/local_data_source/photo_local_data_source.dart';
import 'package:selfdep/features/home/data/models/photo/photo_model.dart';
import 'package:selfdep/features/home/data/models/hive/photo_hive_model.dart';

class PhotoLocalDataSourceImpl implements PhotoLocalDataSource {
  static const String _photosBoxName = 'photos_box';
  static const String _curatedPrefix = 'curated_';
  static const String _searchPrefix = 'search_';

  Box<List<PhotoHiveModel>>? _photosBox;

  Future<Box<List<PhotoHiveModel>>> get photosBox async {
    _photosBox ??= await Hive.openBox<List<PhotoHiveModel>>(_photosBoxName);
    return _photosBox!;
  }

  String _getKey({String? query, int page = 1}) {
    if (query != null && query.isNotEmpty) {
      return '${_searchPrefix}${query}_page_$page';
    }
    return '${_curatedPrefix}page_$page';
  }

  @override
  Future<void> cachePhotos(
    List<Photo> photos, {
    String? query,
    int page = 1,
  }) async {
    final box = await photosBox;
    final key = _getKey(query: query, page: page);
    final hivePhotos = photos
        .map((photo) => PhotoHiveModel.fromPhoto(photo))
        .toList();
    await box.put(key, hivePhotos);
  }

  @override
  Future<List<Photo>> getCachedPhotos({String? query, int page = 1}) async {
    final box = await photosBox;
    final key = _getKey(query: query, page: page);
    final hivePhotos = box.get(key);

    if (hivePhotos == null) {
      return [];
    }

    return hivePhotos.map((hivePhoto) => hivePhoto.toPhoto()).toList();
  }

  @override
  Future<void> clearCache({String? query}) async {
    final box = await photosBox;

    if (query != null && query.isNotEmpty) {
      final keysToDelete = box.keys
          .where((key) => key.toString().startsWith('${_searchPrefix}$query'))
          .toList();
      for (final key in keysToDelete) {
        await box.delete(key);
      }
    } else {
      final keysToDelete = box.keys
          .where((key) => key.toString().startsWith(_curatedPrefix))
          .toList();
      for (final key in keysToDelete) {
        await box.delete(key);
      }
    }
  }

  @override
  Future<bool> hasCachedPhotos({String? query, int page = 1}) async {
    final box = await photosBox;
    final key = _getKey(query: query, page: page);
    return box.containsKey(key);
  }
}
