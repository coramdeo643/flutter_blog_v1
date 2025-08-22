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

// 문제점 고민해보기
// 1. 책임 혼재 : UI로직, 비즈니스 로직, 검증 로직 중복되어있다
// 2. 테스트 어려움 : UI와 비즈니스 로직이 동시에 존재해서 관리 어려움
// 3. 재사용성 저하 : 다른 화면에서 로그인 기능 사용 어려움(책임혼재되어있기에)
/*
--->>> Refactoring!

 */

// 창고 메뉴얼
class SessionNotifier extends Notifier<SessionModel> {
  @override
  SessionModel build() {
    return SessionModel();
  }

  // Login Logic Design - Only for business logic
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      Map<String, dynamic> body =
          await UserRepository().login(username, password);
      if (body["success"] == false) {
        return body;
        // 서버에서 내려준 에러 정보를 그대로 반환 --> UI에서 에러 메시지 출력
      }

      User user = User.fromMap(body["response"]);

      await secureStorage.write(key: "accessToken", value: user.accessToken);

      state = SessionModel(user: user, isLogin: true);

      dio.options.headers["Authorization"] = user.accessToken;

      return {"success": true}; // 로그인 성공 정보 반환
    } catch (e) {
      // Network Error,
      return {
        "success": false,
        "errorMessage": "Network Error",
      };
    }
  }

  // =========================
  // Logout
  Future<void> logout() async {
    try {
      await secureStorage.delete(key: "accessToken");
      state = SessionModel();
      dio.options.headers["Authorization"] = "";
      Logger().d("Logout Success");
    } catch (e) {
      Logger().d("!!!Error to Logout!!!");
      state = SessionModel();
      dio.options.headers["Authorization"] = "";
    }
  }

  // Auto Login
  Future<bool> autoLogin() async {
    try {
      // Step.1 Token Check from SecureStorage
      String? accessToken = await secureStorage.read(key: "accessToken");
      if (accessToken == null) {
        return false;
      }
      // Step.2 Request to AutoLogin to UserRepository
      Map<String, dynamic> body = await UserRepository().autoLogin(accessToken);
      // Step.3 서버에서 받은 사용자 정보를 창고에 다시 넣어야한다
      User user = User.fromMap(body["response"]);
      user.accessToken = accessToken;
      // Step.4 창고 데이터에 로그인된 상태로 업데이트 처리
      state = SessionModel(user: user, isLogin: true);
      // STrp.5 이 후 모든 HTTP 요청에 인증 열쇠 자동 부여하기
      dio.options.headers["Authorization"] = user.accessToken;
      Logger().d("Auto Login Success");
      return true;
    } catch (e) {
      Logger().d("Fail to Auto Login !!! : $e");
      return false;
    }
  }

  // Join
  Future<Map<String, dynamic>> join(
      String username, String email, String password) async {
    try {
      Logger().d("username : $username, email : $email, pwd : $password");
      Map<String, dynamic> body =
          await UserRepository().join(username, email, password);
      if (!body["success"]) {
        return {"success": false, "errorMessage": body["errorMessage"]};
      } // Fail to Join
      return {"success": true}; // Success to Join
    } catch (e) {
      // Network Error,
      return {
        "success": false,
        "errorMessage": "Network Error",
      };
    }
  }
} // end of SessionNotifier

// 실제 창고 개설
final sessionProvider =
    NotifierProvider<SessionNotifier, SessionModel>(() => SessionNotifier());

//--------------------------------------------------------------------------
/*
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

// 문제점 고민해보기
// 1. 책임 혼재 : UI로직, 비즈니스 로직, 검증 로직 중복되어있다
// 2. 테스트 어려움 : UI와 비즈니스 로직이 동시에 존재해서 관리 어려움
// 3. 재사용성 저하 : 다른 화면에서 로그인 기능 사용 어려움(책임혼재되어있기에)
/*
--->>> Refactoring!

 */

// 창고 메뉴얼
class SessionNotifier extends Notifier<SessionModel> {
  // context가 없는 환경에서 navigation 과 알림 처리를 위한 Global key
  ///final mContext = navigatorKey.currentContext!;

  @override
  SessionModel build() {
    // return SessionModel(user: null, isLogin: false);ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(content: content));
    return SessionModel();
  }

  // Login Logic Design - Only for business logic
  Future<void> login(String username, String password) async {
    // 검증 중복 문제??? 굳이 여기서? 단일책임의원칙을 벗어남, 책임들이 혼재되어있음
    // 유효성 검증 Validation = 사용자가 입력한 username & password
    ///bool isValid = ref.read(loginFormProvider.notifier).validate();
    // if (!isValid) {
    //   ScaffoldMessenger.of(mContext)
    //       .showSnackBar(SnackBar(content: Text(" - - - Not Valid - - - ")));
    //   return;
    // }
    //------------------------------------------------------------------------
    Map<String, dynamic> body =
        await UserRepository().login(username, password);
    // if (!body["success"]) {
      // if login fail
      // ScaffoldMessenger.of(mContext)
      //     .showSnackBar(SnackBar(content: Text(" - - - Login Failed - - - ")));
      // return;
    // }
    // // else login success
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

 */
