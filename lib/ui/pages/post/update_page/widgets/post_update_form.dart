import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/providers/global/post/post_update_notifier.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/snackbar_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/data/post.dart';

class PostUpdateForm extends ConsumerWidget {
  final Post post;
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostUpdateForm(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ref.read() - temporally read
    /// ref.watch() - keep watching
    /// ref.listen() - side effect
    final PostUpdateModel model = ref.watch(postUpdateProvider);
    ref.listen<PostUpdateModel>(
      postUpdateProvider,
      (previous, next) {
        if (next.isLoading == false && next.error == null) {
          // side effect 1
          SnackBarUtil.showSuccess(context, "Post Update Success!");
          // side effect 2 : 게시글 상세보기 갱신 / 게시물 목록 보기 갱신
          ref.read(postListProvider.notifier).refreshAfterWriter();
          // Navigator.of(context).pop();
          // Navigator.of(context).pop();
          // 뒤로 뒤로 말고 한번에 화면이동 + 이전 스택 제거
          Navigator.of(context).pushNamed("/post/list");
        }
      },
    );

    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CustomTextFormField(
            controller: _title,
            initValue: post.title,
            hint: "Title",
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
            initValue: post.content,
          ),
          const SizedBox(height: largeGap),
          // 중복 클릭 방지
          CustomElevatedButton(
            text: model.isLoading == true ? "Updating..." : "Post Update",
            click: model.isLoading == true
                ? null
                : () => _handleUpdate(ref, context),
          ),
        ],
      ),
    );
  } // end of build

  void _handleUpdate(WidgetRef ref, BuildContext context) async {
    // 1. form validation
    try {
      if (_formKey.currentState!.validate() == false) {
        return;
      }
      Post updatedPost = post.copyWith(
        title: _title.text.trim(),
        content: _content.text,
        updatedAt: DateTime.now(),
      );
      await ref.read(postUpdateProvider.notifier).updatePost(updatedPost);
    } catch (e) {
      SnackBarUtil.showError(context, "Update Failed!");
    }
  }
}
