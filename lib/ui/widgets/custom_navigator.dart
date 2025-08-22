import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/providers/global/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 창고에 접근할 수 있는 위젯으로 확장해야 한다.
class CustomNavigation extends ConsumerWidget {
  final scaffoldKey;
  const CustomNavigation(this.scaffoldKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionNotifier sessionNotifier = ref.read(sessionProvider.notifier);
    return Container(
      width: getDrawerWidth(context),
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  scaffoldKey.currentState!.openEndDrawer();
                  Navigator.pushNamed(context, "/post/write");
                },
                child: const Text(
                  "Post",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () async {
                  // logout function call
                  await sessionNotifier.logout();
                  scaffoldKey.currentState!.openEndDrawer();
                  Navigator.popAndPushNamed(context, "/login");
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () async {
                  //await sessionNotifier.logout();
                  scaffoldKey.currentState!.openEndDrawer();
                  //Navigator.popAndPushNamed(context, "/login");
                },
                child: const Text(
                  "My Page",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
