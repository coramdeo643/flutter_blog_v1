import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/form/login_form_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/constants/size.dart';
import '../../../../widgets/custom_auth_text_form_field.dart';
import '../../../../widgets/custom_elavated_button.dart';
import '../../../../widgets/custom_text_button.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LoginModel loginModel = ref.watch(loginFormProvider);
    LoginFormNotifier loginFormNotifier = ref.read(loginFormProvider.notifier);
    // JoinModel joinModel = ref.watch(joinProvider);
    // JoinFormNotifier formNotifier = ref.read(joinProvider.notifier);

    return Form(
      child: Column(
        children: [
          CustomAuthTextFormField(
            title: "Username",
            errorText: loginModel.usernameError,
            onChanged: (value) {
              loginFormNotifier.username(value);
            },
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            title: "Password",
            obscureText: true,
            errorText: loginModel.passwordError,
            onChanged: (value) {
              loginFormNotifier.password(value);
            },
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "로그인",
            click: () {
              bool isValid = loginFormNotifier.validate();
              if (isValid) {
                Navigator.popAndPushNamed(context, "/post/list");
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("유효성 검사 실패입니다")),
                );
              }
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
