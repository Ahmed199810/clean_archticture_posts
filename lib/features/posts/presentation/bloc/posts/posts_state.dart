import 'package:clean_archticture_posts/features/posts/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialPostsState extends PostsState {}

class LoadingPostsState extends PostsState {}

class LoadedPostsState extends PostsState {
  final List<Post> posts;

  LoadedPostsState({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class ErrorPostsState extends PostsState {
  final String message;

  ErrorPostsState({required this.message});

  @override
  List<Object?> get props => [message];
}
