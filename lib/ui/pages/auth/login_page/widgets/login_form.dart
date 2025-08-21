import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/constants/size.dart';
import '../../../../widgets/custom_auth_text_form_field.dart';
import '../../../../widgets/custom_elavated_button.dart';
import '../../../../widgets/custom_text_button.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      child: Column(
        children: [
          CustomAuthTextFormField(
            title: "Username",
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            title: "Password",
            obscureText: true,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "로그인",
            click: () {
              Navigator.popAndPushNamed(context, "/post/list");
            },
          ),
          CustomTextButton(
            text: "회원가입 페이지로 이동",
            click: () {
              Navigator.pushNamed(context, "/join");
            },
          )
        ],
      ),
    );
  }
}
