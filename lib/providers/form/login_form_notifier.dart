// 창고 데이터 설계

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../_core/utils/validator_util.dart';

class LoginModel {
  // Input Field Error Msg
  final String username;
  final String password;

  // 각 입력 필드 검증 에러 메시지 Error Msg
  final String usernameError;
  final String passwordError;

  LoginModel(
    this.username,
    this.password,
    this.usernameError,
    this.passwordError,
  );

  // void main() {
  //   LoginModel loginModel1 =
  //       LoginModel("Lee", "1234", "3 letters", "4 letters");
  //   LoginModel loginModel2 =
  //       LoginModel("Lee", "1234", "3 letters", "4 letters");
  //   loginModel1.copyWith(usernameError: "5 letters");
  // }

  // 기존 데이터에서 일부 변경한 값만 받아서 새로운 객체 만드는 코드 작성
  LoginModel copyWith({
    String? username,
    String? password,
    String? usernameError,
    String? passwordError,
  }) {
    return LoginModel(
      username ?? this.username,
      password ?? this.password,
      usernameError ?? this.usernameError,
      passwordError ?? this.passwordError,
    );
  }

  // Debug
  @override
  String toString() {
    return 'LoginModel{username: $username, password: $password, usernameError: $usernameError, passwordError: $passwordError}';
  }
} // end of LoginModel class

// 창고 메뉴얼 설계
class LoginFormNotifier extends AutoDisposeNotifier<LoginModel> {
  @override
  LoginModel build() {
    return LoginModel("", "", "", "");
  }

  // 사용자명 입력시 : 즉시 검증 + 상태 업데이트 기능 구현
  void username(String username) {
    final String error = validateUsername(username);
    Logger().d(error);
    state = state.copyWith(
      username: username,
      usernameError: error,
    );
  }

  // Password
  void password(String password) {
    String passwordError = validatePassword(password);
    if (passwordError.trim().isEmpty) {
      Logger().d(password);
    } else {
      Logger().d(passwordError);
    }
    state = state.copyWith(
      password: password,
      passwordError: passwordError,
    );
  }

  bool validate() {
    final usernameError = validateUsername(state.username);
    final passwordError = validatePassword(state.password);
    if (usernameError.trim().isEmpty && passwordError.trim().isEmpty) {
      Logger().d("이름 값: ${state.username}");
    } else {
      Logger().e("이름 값 오류: $usernameError / 비밀번호 값 오류: $passwordError");
    }
    return usernameError.isEmpty && passwordError.isEmpty;
  }
} // end of LoginFormNotifier class

// 실제 창고를 메모리에 올린다 - 전역 변수로 관리
final loginFormProvider =
    AutoDisposeNotifierProvider<LoginFormNotifier, LoginModel>(
        () => LoginFormNotifier());
// loginFormProvider --> LoginFormNotifier() --> LoginModel()
// ref.read(loginFormProvider);    --> LoginModel()
// ref.read(loginFormProvider.notifier); --> LoginFormNotifier()
