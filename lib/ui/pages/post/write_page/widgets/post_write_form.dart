import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/providers/global/post/post_write_notifier.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWriteForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>(); // for validation
  final _title = TextEditingController(); // title controller
  final _content = TextEditingController(); // content controller

  PostWriteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 게시글 작성 상태 데이터
    // 상태가 변경될 때 마다 build 메서드 다시 호출되어 UI를 업데이트 처리 한다
    final PostWriteModel model = ref.watch(postWriteProivder);
    // 복습 정리
    // 상태를 감시하는 Method
    // ref.read(provider), ref.watch(provider),
    // ref.listen(provider, listener) 활용해보자!
    // 1. build method 내부에서 또는 initState 에서 사용가능
    // 2. 상태 변화에 따른 사이드 이펙트 처리
    // 참고 : 주로 Navigator, Dialog, Snackbar 등 일회성 액션이 필요할 때 사용한다
    ref.listen(
      postWriteProivder,
      (previous, next) {
        if (next.status == PostWriteStatus.success) {
          // Side Effect 1 : Snackbar success MSG
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Post Write Success!"),
            backgroundColor: Colors.green,
          ));
          // Side Effect 2 : Post List Refresh(가능한 notifier 끼리 통신의 자제하자)
          ref.read(postListProvider.notifier).refreshAfterWriter();
          // Side Eggect 3 : Screen change > Navigator.pop
          Navigator.pop(context);
        } else if (next.status == PostWriteStatus.failure) {
          // Side Effect 1 : Snackbar failure MSG
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Post Write Failed!"),
            backgroundColor: Colors.red,
          ));
        }
      },
    );

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTextFormField(
            controller: _title,
            hint: "Title",
            validator: (value) =>
                value?.trim().isEmpty == true ? "제목을 입력하세요!" : null,
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
            validator: (value) =>
                value?.trim().isEmpty == true ? "내용을 입력하세요!" : null,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
              text: model.status == PostWriteStatus.loading
                  ? "Writing..."
                  : "Write",
              click: model.status == PostWriteStatus.loading
                  ? null
                  : () => _handleSubmit(ref)),
        ],
      ),
    );
  }

  //
  void _handleSubmit(WidgetRef ref) {
    // 유효성 검사
    if (_formKey.currentState!.validate()) {
      final title = _title.text.trim();
      final content = _content.text.trim();
      ref.read(postWriteProivder.notifier).writePost(title, content);
    }
    // 사용자가 작성한 값 들어괴
    // 상태관리 비즈니스 로직을 호출(게시글 작성)
  }
}
