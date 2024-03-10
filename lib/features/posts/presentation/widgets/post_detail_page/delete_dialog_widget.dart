import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_bloc.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteDialogWidget extends StatelessWidget {
  final int postId;

  const DeleteDialogWidget({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you Sure ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "No",
          ),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<AddDeleteUpdatePostBloc>(context).add(
              DeletePostEvent(postId: postId),
            );
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}
