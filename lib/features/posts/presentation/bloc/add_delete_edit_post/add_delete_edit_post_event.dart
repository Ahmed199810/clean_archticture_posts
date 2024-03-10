import 'package:clean_archticture_posts/features/posts/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

abstract class AddDeleteEditPostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddPostEvent extends AddDeleteEditPostEvent {
  final Post post;

  AddPostEvent({required this.post});

  @override
  List<Object?> get props => [post];
}

class UpdatePostEvent extends AddDeleteEditPostEvent {
  final Post post;

  UpdatePostEvent({required this.post});

  @override
  List<Object?> get props => [post];
}

class DeletePostEvent extends AddDeleteEditPostEvent {
  final int postId;

  DeletePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}
