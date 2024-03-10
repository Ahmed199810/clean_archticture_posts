import 'package:clean_archticture_posts/core/widgets/loading_widget.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/posts/posts_state.dart';
import 'package:clean_archticture_posts/features/posts/presentation/pages/post_add_update_page.dart';
import 'package:clean_archticture_posts/features/posts/presentation/widgets/posts_page/message_display_widget.dart';
import 'package:clean_archticture_posts/features/posts/presentation/widgets/posts_page/posts_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingBtn(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Posts"),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is LoadingPostsState) {
            return const LoadingWidget();
          } else if (state is LoadedPostsState) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: PostsListWidget(posts: state.posts),
            );
          } else if (state is ErrorPostsState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Widget _buildFloatingBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const PostAddUpdatePage(isUpdatePost: false)));
      },
      child: const Icon(Icons.add),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<PostsBloc>(context).add(RefreshPostsEvent());
  }
}
