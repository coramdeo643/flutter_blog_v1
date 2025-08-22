import 'package:flutter_blog/_core/data/models/repository/post_repository.dart';
import 'package:flutter_blog/_core/data/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../_core/utils/validator_util.dart';

class PostWriteModel {
  final String title;
  final String content;

  final String titleError;
  final String contentError;

  PostWriteModel({
    required this.title,
    required this.content,
    required this.titleError,
    required this.contentError,
  });

  PostWriteModel.fromMap(Map<String, dynamic> data)
      : title = data["title"],
        content = data["content"],
        titleError = data["titleError"],
        contentError = data["contentError"];

  @override
  String toString() {
    return 'PostWriteModel{title: $title, content: $content}';
  }
}

class PostWriteNotifier extends Notifier<PostWriteModel> {
  @override
  PostWriteModel build() {
    return PostWriteModel(
      title: "",
      content: "",
      titleError: "",
      contentError: "",
    );
  }

  // savePost
  Future<Map<String, dynamic>> savePost(String title, String content) async {
    try {
      Map<String, dynamic> body = await PostRepository().write(title, content);
      if (body["success"] == false) {
        return {"success": false, "errorMessage": body["errorMessage"]};
      } // Fail to write
      //Post post = Post.fromMap(body["response"]);
      return {"success": true}; // Success to write
    } catch (e) {
      return {"success": false, "errorMessage": "Network Error"};
    }
  }

  // deletePost
  Future<Map<String, dynamic>> deletePost(int postId) async {
    try {
      Map<String, dynamic> body = await PostRepository().deleteOne(postId);
      if (body["success"] == false) {
        return {"success": false, "errorMessage": body["errorMessage"]};
      } // Fail to delete
      return {"success": true};
    } catch (e) {
      return {"success": false, "errorMessage": "Network Error"};
    }
  }
}

final postWriteProvider = NotifierProvider<PostWriteNotifier, PostWriteModel>(
    () => PostWriteNotifier());
