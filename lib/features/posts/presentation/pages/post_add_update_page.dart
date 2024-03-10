import 'package:clean_archticture_posts/core/util/snackbar_message.dart';
import 'package:clean_archticture_posts/core/widgets/loading_widget.dart';
import 'package:clean_archticture_posts/features/posts/domain/entities/post.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_bloc.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_state.dart';
import 'package:clean_archticture_posts/features/posts/presentation/pages/posts_page.dart';
import 'package:clean_archticture_posts/features/posts/presentation/widgets/post_add_update_page/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostAddUpdatePage extends StatelessWidget {
  final Post? post;
  final bool isUpdatePost;

  const PostAddUpdatePage({super.key, this.post, required this.isUpdatePost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(isUpdatePost ? "Edit Post" : "Add Post"),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocConsumer<AddDeleteUpdatePostBloc, AddDeleteUpdatePostState>(
            builder: (context, state) {
          if (state is LoadingAddDeleteUpdatePostState) {
            return const LoadingWidget();
          }
          return FormWidget(isUpdatePost: isUpdatePost, post: post);
        }, listener: (context, state) {
          if (state is MessageAddDeleteUpdatePostState) {
            SnackBarMessage()
                .showSuccessSnackBar(message: state.message, context: context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const PostsPage()),
                (route) => false);
          } else if (state is ErrorAddDeleteUpdatePostState) {
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          }
        }),
      ),
    );
  }
}
