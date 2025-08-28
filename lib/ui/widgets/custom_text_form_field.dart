import 'package:flutter/material.dart';

// 재사용 가능한 위젯으로 설계 하기 위함
// 맞춤 기능을 추가하기 위해 재설계 한다~
class CustomTextFormField extends StatefulWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final String? initValue; // 초기값
  // CustomText추가 기능
  final String? Function(String?)? validator; // for 유효성 검사

  const CustomTextFormField({
    // 생성자...
    Key? key,
    required this.hint,
    this.obscureText = false,
    required this.controller,
    this.initValue = "",
    this.validator, // 선택적 매개변수(넣어도 안넣어도 된다 Optional)
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  void initState() {
    super.initState();
    if (widget.initValue != null && widget.initValue!.isNotEmpty) {
      widget.controller.text = widget.initValue!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: "Enter ${widget.hint}",
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
    );
  }
}
