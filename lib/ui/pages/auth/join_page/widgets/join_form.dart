import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/form/join_form_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/constants/size.dart';
import '../../../../widgets/custom_auth_text_form_field.dart';
import '../../../../widgets/custom_elavated_button.dart';
import '../../../../widgets/custom_text_button.dart';

// ConsumerWidget
class JoinForm extends ConsumerWidget {
  const JoinForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State value watch
    JoinModel joinModel = ref.watch(joinProvider);

    return Form(
        child: Column(
      children: [
        CustomAuthTextFormField(
          title: "Username",
          errorText: joinModel.usernameError,
          onChanged: (value) {
            // value = input text value(username) by user
            ref.read(joinProvider.notifier).username(value);
          },
        ),
        const SizedBox(height: mediumGap),
        CustomAuthTextFormField(
          title: "Email",
          errorText: joinModel.emailError,
          onChanged: (value) {
            ref.read(joinProvider.notifier).email(value);
          },
        ),
        const SizedBox(height: mediumGap),
        CustomAuthTextFormField(
          title: "Password",
          errorText: joinModel.passwordError,
          obscureText: true,
          onChanged: (value) {
            ref.read(joinProvider.notifier).password(value);
          },
        ),
        const SizedBox(height: largeGap),
        CustomElevatedButton(
          text: "회원가입",
          click: () {
            //
          },
        ),
        CustomTextButton(
          text: "로그인 페이지로 이동",
          click: () {
            Navigator.pushNamed(context, "/login");
          },
        ),
      ],
    ));
  }
}
