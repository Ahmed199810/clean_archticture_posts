import 'package:clean_archticture_posts/features/posts/domain/entities/post.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_bloc.dart';
import 'package:clean_archticture_posts/features/posts/presentation/bloc/add_delete_edit_post/add_delete_edit_post_event.dart';
import 'package:clean_archticture_posts/features/posts/presentation/widgets/post_add_update_page/form_submit_btn.dart';
import 'package:clean_archticture_posts/features/posts/presentation/widgets/post_add_update_page/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormWidget extends StatefulWidget {
  final bool isUpdatePost;
  final Post? post;

  const FormWidget({super.key, required this.isUpdatePost, this.post});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _bodyeCtrl = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdatePost) {
      _titleCtrl.text = widget.post!.title;
      _bodyeCtrl.text = widget.post!.body;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormFieldWidget(
              name: "Title", multiLines: false, controller: _titleCtrl),
          TextFormFieldWidget(
              name: "Body", multiLines: true, controller: _bodyeCtrl),
          FormSubmitBtn(
              isUpdatePost: widget.isUpdatePost,
              onPressed: validateFormThenUpdateOrAddPost),
        ],
      ),
    );
  }

  void validateFormThenUpdateOrAddPost() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final post = Post(
          id: widget.isUpdatePost ? widget.post!.id : null,
          title: _titleCtrl.text,
          body: _bodyeCtrl.text);

      if (widget.isUpdatePost) {
        BlocProvider.of<AddDeleteUpdatePostBloc>(context)
            .add(UpdatePostEvent(post: post));
      } else {
        BlocProvider.of<AddDeleteUpdatePostBloc>(context)
            .add(AddPostEvent(post: post));
      }
    }
  }
}
