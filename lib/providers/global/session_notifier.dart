// 세션이라는 데이터를 구조화 해보자
// 창고 데이터 구상하기

import 'package:flutter/material.dart'
    show ScaffoldMessenger, SnackBar, Text, Navigator;
import 'package:flutter_blog/_core/data/models/repository/user_repository.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/providers/form/join_form_notifier.dart';
import 'package:flutter_blog/providers/form/login_form_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../_core/data/user.dart';

class SessionModel {
  User? user;
  bool? isLogin;

  SessionModel({this.user, this.isLogin = false});

  @override
  String toString() {
    return 'SessionModel{user: $user, isLogin: $isLogin}';
  }
} // end of SessionModel

// 창고 메뉴얼
class SessionNotifier extends Notifier<SessionModel> {
  // context가 없는 환경에서 navigation 과 알림 처리를 위한 Global key
  final mContext = navigatorKey.currentContext!;

  @override
  SessionModel build() {
    // return SessionModel(user: null, isLogin: false);ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(content: content));
    return SessionModel();
  }

  // Login Logic Design
  Future<void> login(String username, String password) async {
    // 유효성 검증 Validation = 사용자가 입력한 username & password
    bool isValid = ref.read(loginFormProvider.notifier).validate();
    if (!isValid) {
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text(" - - - Not Valid - - - ")));
      return;
    }
    Map<String, dynamic> body =
        await UserRepository().login(username, password);
    if (!body["success"]) {
      // if login fail
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text(" - - - Login Failed - - - ")));
      return;
    }
    // else login success
    // 서버에서 받은 사용자 정보를 앱에서 사용할 수 있는 형태로 변환
    User user = User.fromMap(body["response"]);
    // Local 저장소에 JWT 토큰을 저장해두자.
    // like more secured SharedPreferences lib
    await secureStorage.write(key: "accessToken", value: user.accessToken);
    //
    state = SessionModel(user: user, isLogin: true);

    // 로그인 성공 이후에 서버측에 통신 요청할 때마다 JWT 토큰을 주입해야된다
    dio.options.headers["Authorization"] = user.accessToken;

    // 화면이동
    Navigator.pushNamed(mContext, "/post/list"); // to the PostList!
  }

  // ==========================================================================
  // Logout

  // Auto Login

  // Join
  Future<void> join(String username, String email, String password) async {
    Logger().d("username : $username, email : $email, pwd : $password");
    // Validation
    bool isValid = ref.read(joinProvider.notifier).validate();
    if (!isValid) {
      // if not valid!
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text(" - - - Not Valid - - - ")));
      return;
    }
    Map<String, dynamic> body =
        await UserRepository().join(username, email, password);
    if (!body["success"]) {
      // if not success
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text(body["errorMessage"])));
      return;
    }
    // 회원가입 후 로그인 페이지로 이동 처리(자동 로그인)
    Navigator.pushNamed(mContext, "/login");
  }
} // end of SessionNotifier

// 실제 창고 개설
final sessionProvider =
    NotifierProvider<SessionNotifier, SessionModel>(() => SessionNotifier());
