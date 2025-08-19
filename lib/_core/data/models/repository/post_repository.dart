import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/data/post.dart';
import 'package:logger/logger.dart';
import '../../../utils/my_http.dart';
import 'user_repository.dart';
import 'package:flutter/material.dart';

class PostRepository {
  String auth = "Authorization";

  // Post Write Request
  Future<Map<String, dynamic>> post(
      String title, String content, String accessToken) async {
    final requestBody = {
      "title": title,
      "content": content,
    };
    Response response = await dio.post(
      "/api/post",
      data: requestBody,
      options: Options(headers: {"Authorization": accessToken}),
    );
    final responseBody = response.data;
    Logger().d(responseBody);
    return requestBody;
  }

  // Post List Request
  Future<Map<String, dynamic>> findAll(String accessToken) async {
    Response response = await dio.get(
      "/api/post?page=0",
      options: Options(headers: {"Authorization": accessToken}),
    );
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // Post Detail Request
  Future<Map<String, dynamic>> findById(int id, String accessToken) async {
    Response response = await dio.get("/api/post/$id",
        options: Options(headers: {auth: accessToken}));
    final rBody = response.data;
    Logger().d(rBody);
    return rBody;
  }

  // Post Delete Request
  Future<Map<String, dynamic>> deleteById(int id, String accessToken) async {
    Response response = await dio.delete("/api/post/$id",
        options: Options(headers: {auth: accessToken}));
    final rBody = response.data;
    Logger().d(rBody);
    return rBody;
  }

  // Post Update Request
  Future<Map<String, dynamic>> updateById(
      String title, String content, int id, String accessToken) async {
    final requestBody = {"title": title, "content": content};
    Response response = await dio.put(
      "/api/post/$id",
      data: requestBody,
      options: Options(headers: {auth: accessToken}),
    );
    final rBody = response.data;
    Logger().d(rBody);
    return rBody;
  }
}

void main() {
  String t =
      "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjo1LCJleHAiOjE3NTU3NTg4ODksInVzZXJuYW1lIjoidGVzdDAyIn0.2bDTgJirrHG41fD0e7ptIZcLFcvqYdJI2GgSlwwFTO-hhONUsVCEK7LclbeOlSUGUuC4QxtKzIhQsKOoabnpVA";
  //UserRepository().login("test02", "1234");
  //PostRepository().post("title123", "content123", t);
  //PostRepository().findAll(t);
  //PostRepository().findById(10, t);
  //PostRepository().deleteById(24, t); // 삭제 권한 없음?
  PostRepository().updateById("title777", "content777", 25, t);
}
