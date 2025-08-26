import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  // 비활성화 기능을 추가하기 위해 nullable로 변경 처리함!!!
  // 중복 클릭 방지용!
  final VoidCallback? click; // typedef

  const CustomElevatedButton({required this.text, required this.click});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white12,
      ),
      onPressed: click,
      child: Text("$text"),
    );
  }
}
