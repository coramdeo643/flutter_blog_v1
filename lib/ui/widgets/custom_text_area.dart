import 'package:flutter/material.dart';

// 여러줄 입력하는 TextField
class CustomTextArea extends StatefulWidget {
  final String? initValue; // 초기값
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator; // for validation

  const CustomTextArea({
    Key? key,
    required this.hint,
    required this.controller,
    this.validator,
    this.initValue = "",
  }) : super(key: key);

  @override
  State<CustomTextArea> createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: widget.controller,
        maxLines: 15, // Able to input multiple lines
        decoration: InputDecoration(
          hintText: "Enter ${widget.hint}",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
