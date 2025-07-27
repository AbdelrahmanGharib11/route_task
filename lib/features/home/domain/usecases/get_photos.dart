import 'package:selfdep/features/home/domain/entities/photo_entity.dart';
import 'package:selfdep/features/home/domain/repository/photo_repository.dart';

class GetCuratedPhotos {
  final PhotoRepository _repository;

  GetCuratedPhotos(this._repository);

  Future<List<PhotoEntity>> call({int page = 1, int perPage = 20}) async {
    return await _repository.getCuratedPhotos(page: page, perPage: perPage);
  }
}
