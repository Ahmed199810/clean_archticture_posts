import 'package:clean_archticture_posts/core/error/failures.dart';
import 'package:clean_archticture_posts/core/strings/failures.dart';
import 'package:clean_archticture_posts/features/posts/domain/usecases/get_all_posts.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/posts/posts_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUseCase getAllPosts;

  PostsBloc({required this.getAllPosts}) : super(InitialPostsState()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts.call();
        failureOrPosts.fold((failure) {
          emit(ErrorPostsState(message: _mapFailureToMessage(failure)));
        }, (posts) {
          emit(LoadedPostsState(posts: posts));
        });
      } else if (event is RefreshPostsEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts.call();
        failureOrPosts.fold((failure) {
          emit(ErrorPostsState(message: _mapFailureToMessage(failure)));
        }, (posts) {
          emit(LoadedPostsState(posts: posts));
        });
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error";
    }
  }
}
