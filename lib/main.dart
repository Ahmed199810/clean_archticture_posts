import 'package:clean_archticture_posts/core/app_theme.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_bloc.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/posts/presentation/pages/posts_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => di.sl<PostsBloc>()..add(GetAllPostsEvent())),
        BlocProvider(create: (_) => di.sl<AddDeleteUpdatePostBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Posts App',
        theme: appTheme,
        home: const PostsPage(),
      ),
    );
  }
}