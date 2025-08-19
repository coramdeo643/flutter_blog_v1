import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../utils/my_http.dart';
import 'package:flutter/material.dart';

class UserRepository {
  // JoinRequest - POST
  Future<Map<String, dynamic>> join(
      String username, String email, String password) async {
    // 1. 요청 데이터 구성 - ERP 구조로 설계
    final requestBody = {
      "username": username,
      "email": email,
      "password": password,
    };
    // 2. HTTP POST 요청
    Response response = await dio.post("/join", data: requestBody);

    // 3. Response
    final responseBody = response.data;
    Logger().d(responseBody); // 개발용 로깅 처리

    // 4. Return
    return responseBody;
  }

// Login Request
  Future<Map<String, dynamic>> login(String username, String password) async {
    final requestBody = {
      "username": username,
      "password": password,
    };
    Response response = await dio.post("/login", data: requestBody);
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

// Auto Login Request - if token is valid, return user info!
  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    Response response = await dio.post(
      "/auto/login",
      options: Options(headers: {"Authorization": accessToken}),
    );
    Map<String, dynamic> responseBody = response.data;
    Logger().i(responseBody);
    return responseBody;
  }
}

void main() {
  // UserRepository().join("test02", "admin2@admin.com", "1234");
  // UserRepository().login("test02", "1234");
  UserRepository().autoLogin(
      "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjo1LCJleHAiOjE3NTU3NTY3MjUsInVzZXJuYW1lIjoidGVzdDAyIn0.Bx_kqISvYJW1B2GpInH7x_lKyjd37qcjL6CpwbAunNnShnKuKsgAcdyn0GpCqFIdDFASgBvu1r6RNjSMQfngMQ");
}
