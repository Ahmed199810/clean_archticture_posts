import 'package:clean_archticture_posts/core/error/exception.dart';
import 'package:clean_archticture_posts/core/error/failures.dart';
import 'package:clean_archticture_posts/features/posts/data/datasources/post_local_datasource.dart';
import 'package:clean_archticture_posts/features/posts/data/datasources/post_remote_datasource.dart';
import 'package:clean_archticture_posts/features/posts/data/models/post_model.dart';
import 'package:clean_archticture_posts/features/posts/domain/entities/post.dart';
import 'package:clean_archticture_posts/features/posts/domain/repositories/posts_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/network_info.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostsRepositoryImpl implements PostsRepository {
  final PostRemoteDatasource remoteDatasource;
  final PostLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl(
      {required this.remoteDatasource,
      required this.localDatasource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel = PostModel(title: post.title, body: post.body);
    return await _getMessage(() => remoteDatasource.addPost(postModel));
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async {
    return await _getMessage(() => remoteDatasource.deletePost(id));
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDatasource.getAllPosts();
        localDatasource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDatasource.getCachePosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);
    return await _getMessage(() => remoteDatasource.updatePost(postModel));
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
