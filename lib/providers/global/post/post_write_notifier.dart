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

  PostWriteModel copyWith({
    String? title,
    String? content,
    String? titleError,
    String? contentError,
  }) {
    return PostWriteModel(
      title: title ?? this.title,
      content: content ?? this.content,
      titleError: titleError ?? this.titleError,
      contentError: contentError ?? this.contentError,
    );
  }

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

  void title(String title) {
    final String error = validateTitle(title);
    Logger().d(error);
    state = state.copyWith(
      title: title,
      titleError: error,
    );
  }

  void content(String content) {
    final String error = validateContent(content);
    Logger().d(error);
    state = state.copyWith(
      content: content,
      contentError: error,
    );
  }

  // savePost
  Future<Map<String, dynamic>> savePost(String title, String content) async {
    try {
      Map<String, dynamic> body = await PostRepository().write(title, content);
      Logger().e(body);
      if (body["success"] == false) {
        return {"success": false, "errorMessage": body["errorMessage"]};
      } // Fail to write
      Post post = Post.fromMap(body["response"]);
      Logger().e(post);

      return {"success": true}; // Success to write
    } catch (e) {
      return {"success": false, "errorMessage": "Network Error"};
    }
  }
}

final postWriteProvider = NotifierProvider<PostWriteNotifier, PostWriteModel>(
    () => PostWriteNotifier());
