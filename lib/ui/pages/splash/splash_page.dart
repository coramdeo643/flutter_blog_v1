import 'package:flutter/material.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/providers/form/login_form_notifier.dart';
import 'package:flutter_blog/providers/global/session_notifier.dart';
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
    await Future.delayed(Duration(seconds: 2));
    try {
      final isLogined = await ref.read(sessionProvider.notifier).autoLogin();
      if (isLogined) {
        Navigator.pushNamed(context, "/post/list");
      } else {
        Navigator.pushNamed(context, "/login");
      }
    } catch (e) {
      Navigator.pushNamed(context, "/login");
    }
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
