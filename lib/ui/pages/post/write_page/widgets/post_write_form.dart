import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/providers/global/post/post_write_notifier.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers/global/post/post_list_notifier.dart';

class PostWriteForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostWriteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTextFormField(
            hint: "Title",
            controller: _title,
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "Write",
            click: () async {
              final Map<String, dynamic> result =
                  await ref.read(postWriteProvider.notifier).savePost(
                        _title.text,
                        _content.text,
                      );
              if (result["success"] == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Fail to write post")),
                );
              } else {
                ref.read(postListProvider.notifier).refreshPosts();
                Navigator.pushReplacementNamed(context, "/post/list");
              }
            },
          ),
        ],
      ),
    );
  }
}
