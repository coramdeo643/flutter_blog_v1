// Complex Warehouse Design

// 1.1 Join Form Model Design(What kinds of data should I have?)

import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class JoinModel {
  final String username;
  final String email;
  final String password;

  // 각 필드의 검증 에러 Msg
  final String usernameError;
  final String emailError;
  final String passwordError;

  JoinModel({
    required this.username,
    required this.email,
    required this.password,
    required this.usernameError,
    required this.emailError,
    required this.passwordError,
  });

  // 불변 객체에서 일부만 변경한 새 객체 생성 편의 기능
  JoinModel copyWith({
    String? username, // null 이면 기존 값 유지, 값이 주어지면 변경
    String? email,
    String? password,
    String? usernameError,
    String? emailError,
    String? passwordError,
  }) {
    return JoinModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      usernameError: usernameError ?? this.usernameError,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  // 개발용 디버그 코드
  @override
  String toString() {
    return "JoinModel(username: $username, email: $email, password: $password, usernameError: $usernameError, emailError: $emailError, passwordError: $passwordError)";
  }
}

// 1.2. 창고 메뉴얼 설계
class JoinFormNotified extends Notifier<JoinModel> {
  @override
  JoinModel build() {
    return JoinModel(
      username: "",
      email: "",
      password: "",
      usernameError: "",
      emailError: "",
      passwordError: "",
    );
  }

  // 사용자명 입력서 : 즉시 검증 + 상태 업데이트 기능 구현
  void username(String username) {
    final String error = validateUsername(username);
    Logger().d(error);
    state = state.copyWith(
      username: username,
      usernameError: error,
    );
  }

  // 이메일 입력시, 즉시 검증 + 상태 업데이트 기능 구현
  void email(String email) {
    final String error = validateEmail(email);
    Logger().d(error);
    state = state.copyWith(
      email: email,
      emailError: error,
    );
  }

// 비밀번호 입력시,즉시검증
  void password(String password) {
    final String error = validatePassword(password);
    Logger().d(error);
    state = state.copyWith(
      password: password,
      passwordError: error,
    );
  }

// 최종 검증 - 회원 가입 버튼 누를 동작 준리
}

// 1.3 실제 창고 개설
final joinProvider =
    NotifierProvider<JoinFormNotified, JoinModel>(() => JoinFormNotified());
