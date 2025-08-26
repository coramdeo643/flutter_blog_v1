import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/data/post.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
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
    final PostWriteNotifier notifier = ref.read(postWriteProivder.notifier);

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
