import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';

class CustomAuthTextFormField extends StatelessWidget {
  final String title; // label title
  final String errorText; // error msg when input is wrong
  final Function(String)? onChanged; // when input has changed
  final bool obscureText;

  CustomAuthTextFormField({
    required this.title,
    this.errorText = "",
    this.onChanged,
    this.obscureText = false,
  }); // passwords hide or not

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: smallGap),
        TextFormField(
          //initialValue: "ssar",
          onChanged: onChanged,
          obscureText: obscureText,
          decoration: InputDecoration(
            errorText: errorText.isEmpty ? null : errorText,
            hintText: "Enter $title",
            enabledBorder: OutlineInputBorder(
              // 3. 기본 TextFormField 디자인
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              // 4. 손가락 터치시 TextFormField 디자인
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              // 5. 에러발생시 TextFormField 디자인
              borderRadius: BorderRadius.circular(20),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // 5. 에러가 발생 후 손가락을 터치했을 때 TextFormField 디자인
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
