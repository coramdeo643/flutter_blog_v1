import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/data/post.dart';
import 'package:flutter_blog/_core/data/replies.dart';
import 'package:flutter_blog/_core/data/user.dart';
import 'package:logger/logger.dart';
import '../../../utils/my_http.dart';
import 'user_repository.dart';
import 'package:flutter/material.dart';

void main() {
  //UserRepository().login("ssar", "1234");
  final _accessToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NTU4MjIwMzUsInVzZXJuYW1lIjoic3NhciJ9.HxKgzGfZRNpvXn0f0B5-3Wo9dv5Kg72xvr61Hqi4wYxpxlRCQX5Fk7ZKGJ5zuA-Ic-SndjM-9R2spBQ2_Fje6Q";
  dio.options.headers['Authorization'] = 'Bearer $_accessToken';
  Post post = Post(
    id: 1,
    title: "updated title",
    content: "updated content",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    bookmarkCount: 1,
    user: User(),
    //replies: Replies(),
  );
  //PostRepository().write("title999", "content999");
  //PostRepository().getList(page: 2);
  //PostRepository().getOne(11);
  //PostRepository().deleteOne(24);
  PostRepository().updateOne(post);
}

class PostRepository {
  // Post Write Request
  Future<Map<String, dynamic>> write(String title, String content) async {
    Response response = await dio.post("/api/post", data: {
      "title": title,
      "content": content,
    });
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // Post List Request(Pagination)
  Future<Map<String, dynamic>> getList({int page = 0}) async {
    Response response =
        await dio.get("/api/post", queryParameters: {"page": page});
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // Post Detail Request
  Future<Map<String, dynamic>> getOne(int postId) async {
    Response response = await dio.get("/api/post/$postId");
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // Post Delete Request
  Future<Map<String, dynamic>> deleteOne(int postId) async {
    Response response = await dio.delete("/api/post/$postId");
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // Post Update Request
  Future<Map<String, dynamic>> updateOne(Post post) async {
    Response response = await dio.put("/api/post/${post.id}", data: {
      "title": post.title,
      "content": post.content,
    });
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }
}
