import 'package:flutter/material.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/providers/form/login_form_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    // Auto Login Process
    super.initState();
    _performAutoLogin();
  }

  void _performAutoLogin() async {
    // stay 2 seconds
    await Future.delayed(Duration(seconds: 2));
    // Go to Login
    //Navigator.pushNamed(context, "/login");

    try {
      // if already logined, go to post list page
      // else go to login page
      if (ref.read(loginFormProvider.notifier).validate()) {
        Navigator.pushNamed(context, "/post/list");
      } else {
        Navigator.pushNamed(context, "/login");
      }
    } catch (e) {
      Navigator.pushNamed(context, "/login");
    }
    // Auto login Request
    // 결과에 따라서 로그인 페이지 게시글 목록 페이지 분기 처리
    // 혹시 오류 발생하면 그냥 로그인 페이지로...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/login");
        },
        child: Icon(Icons.arrow_circle_right),
      ),
    );
  }
}
