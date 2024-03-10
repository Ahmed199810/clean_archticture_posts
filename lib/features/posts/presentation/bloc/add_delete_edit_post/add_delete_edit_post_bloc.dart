import 'package:clean_archticture_posts/core/error/failures.dart';
import 'package:clean_archticture_posts/core/strings/failures.dart';
import 'package:clean_archticture_posts/core/strings/messages.dart';
import 'package:clean_archticture_posts/features/posts/domain/usecases/add_post.dart';
import 'package:clean_archticture_posts/features/posts/domain/usecases/delete_post.dart';
import 'package:clean_archticture_posts/features/posts/domain/usecases/update_post.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_event.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDeleteUpdatePostBloc
    extends Bloc<AddDeleteEditPostEvent, AddDeleteUpdatePostState> {
  final AddPostUseCase addPost;
  final UpdatePostUseCase updatePost;
  final DeletePostUseCase deletePost;

  AddDeleteUpdatePostBloc(
      {required this.updatePost,
      required this.deletePost,
      required this.addPost})
      : super(AddDeleteUpdatePostInitialState()) {
    on<AddDeleteEditPostEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDone = await addPost.call(event.post);
        failureOrDone.fold((failure) {
          emit(ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure)));
        }, (_) {
          emit(MessageAddDeleteUpdatePostState(message: ADD_SUCCESS_MESSAGE));
        });
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDone = await updatePost.call(event.post);
        failureOrDone.fold((failure) {
          emit(ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure)));
        }, (_) {
          emit(
              MessageAddDeleteUpdatePostState(message: UPDATE_SUCCESS_MESSAGE));
        });
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDone = await deletePost.call(event.postId);
        failureOrDone.fold((failure) {
          emit(ErrorAddDeleteUpdatePostState(
              message: _mapFailureToMessage(failure)));
        }, (_) {
          emit(
              MessageAddDeleteUpdatePostState(message: DELETE_SUCCESS_MESSAGE));
        });
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error";
    }
  }
}
