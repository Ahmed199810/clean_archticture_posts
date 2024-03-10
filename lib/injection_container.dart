import 'package:clean_archticture_posts/core/network/network_info.dart';
import 'package:clean_archticture_posts/features/posts/data/datasources/post_local_datasource.dart';
import 'package:clean_archticture_posts/features/posts/data/datasources/post_remote_datasource.dart';
import 'package:clean_archticture_posts/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:clean_archticture_posts/features/posts/domain/repositories/posts_repository.dart';
import 'package:clean_archticture_posts/features/posts/domain/usecases/add_post.dart';
import 'package:clean_archticture_posts/features/posts/domain/usecases/delete_post.dart';
import 'package:clean_archticture_posts/features/posts/domain/usecases/get_all_posts.dart';
import 'package:clean_archticture_posts/features/posts/domain/usecases/update_post.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_bloc.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  // posts

  // Bloc

  sl.registerFactory(() => PostsBloc(getAllPosts: sl()));
  sl.registerFactory(() => AddDeleteUpdatePostBloc(
      updatePost: sl(), deletePost: sl(), addPost: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetAllPostsUseCase(sl()));
  sl.registerLazySingleton(() => AddPostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));

  // Repository

  sl.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
      remoteDatasource: sl(), localDatasource: sl(), networkInfo: sl()));

  // Data Sources
  sl.registerLazySingleton<PostRemoteDatasource>(
      () => PostRemoteDatasourceImpl(client: sl()));
  sl.registerLazySingleton<PostLocalDatasource>(
      () => PostLocalDatasourceImpl(sharedPreferences: sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
