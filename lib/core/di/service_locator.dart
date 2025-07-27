import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:selfdep/core/network/api_config.dart';
import 'package:selfdep/features/home/data/data_source/remote_data_source/photo_remote_data_source.dart';
import 'package:selfdep/features/home/data/data_source/remote_data_source/photo_remote_data_source_impl.dart';
import 'package:selfdep/features/home/data/data_source/local_data_source/photo_local_data_source.dart';
import 'package:selfdep/features/home/data/data_source/local_data_source/photo_local_data_source_impl.dart';
import 'package:selfdep/features/home/data/models/hive/photo_hive_model.dart';
import 'package:selfdep/features/home/domain/repository/photo_repository.dart';
import 'package:selfdep/features/home/data/repository/photo_repository_impl.dart';
import 'package:selfdep/features/home/domain/usecases/get_photos.dart';
import 'package:selfdep/features/home/presentation/cubit/photo_cubit.dart';
import 'package:selfdep/core/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PhotoHiveModelAdapter());
  Hive.registerAdapter(PhotoSrcHiveModelAdapter());

  final dioClient = DioClient();
  sl.registerLazySingleton<Dio>(() => dioClient.dio);

  sl.registerLazySingleton<PhotoRemoteDataSource>(
    () => PhotoRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PhotoLocalDataSource>(
    () => PhotoLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<PhotoRepository>(
    () => PhotoRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => GetCuratedPhotos(sl()));

  sl.registerFactory(() => PhotoCubit(getCuratedPhotos: sl()));

  sl.registerLazySingleton(() => ThemeCubit());
}
