// 서버 통신 요청 결과 -->
// 통신 -- 로딩 -- 응답 -- 성공 / 실패
// Post Update Model

import 'package:flutter_blog/_core/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../_core/data/post.dart';

class PostUpdateModel {
  final bool? isLoading;
  final String? error;
  // final Post updatePost;

  PostUpdateModel({this.isLoading, this.error});

  PostUpdateModel copyWith({
    bool? isLoading,
    String? error,
  }) {
    return PostUpdateModel(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'PostUpdateModel{isLoading: $isLoading, error: $error}';
  }
} // end of Post Update Model

// 게시글 수정 비즈니스 모델 (manual)
class PostUpdateNotifier extends AutoDisposeNotifier<PostUpdateModel> {
  @override
  PostUpdateModel build() {
    ref.onDispose(() {
      Logger()
          .d("================= PostUpdateNotifier disposed! =============");
    });
    return PostUpdateModel();
  }

  Future<Map<String, dynamic>> updatePost(Post post) async {
    try {
      state = state.copyWith(isLoading: true);
      Map<String, dynamic> response = await PostRepository().updateOne(post);
      if (response['success']) {
        state = state.copyWith(isLoading: false);
        return {"success": true, "message": "!!! Post Update Success !!!"};
      } else {
        state =
            state.copyWith(isLoading: false, error: response['errorMessage']);
        return {"success": false, "message": response['errorMessage']};
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return {"success": false, "errorMessage": "Post Update Failed"};
    }
  }
}

final postUpdateProvider =
    AutoDisposeNotifierProvider<PostUpdateNotifier, PostUpdateModel>(
        () => PostUpdateNotifier());

// import 'package:flutter_blog/providers/global/post/post_write_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logger/logger.dart';
//
// import '../../../_core/data/models/repository/post_repository.dart';
// import '../../../_core/data/post.dart';
//
// class PostUpdateModel {
//   final PostWriteStatus status;
//   final Post updatedPost;
//   final String? message;
//   final bool isLoading;
//   final String? error;
//
//   PostUpdateModel({
//     this.status = PostWriteStatus.initial,
//     required this.updatedPost,
//     this.message,
//     this.isLoading = false,
//     this.error,
//   });
//
//   // PostUpdateModel.fromMap(Map<String, dynamic> data)
//   //     : post = Post.fromMap(data),
//   //       isLoading = false,
//   //       error = null;
//
//   PostUpdateModel copyWith({
//     PostWriteStatus? status,
//     Post? updatedPost,
//     String? message,
//     bool? isLoading,
//     String? error,
//   }) {
//     return PostUpdateModel(
//       status: status ?? this.status,
//       updatedPost: updatedPost ?? this.updatedPost,
//       message: message ?? this.message,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
//
//   @override
//   String toString() {
//     return 'PostUpdateModel{status: $status, updatedPost: $updatedPost, message: $message, isLoading: $isLoading, error: $error}';
//   }
// }
//
// class PostUpdateNotifier
//     extends AutoDisposeFamilyNotifier<PostUpdateModel?, int> {
//   @override
//   PostUpdateModel? build(int postId) {
//     Logger().d("Update ID : $postId");
//     ref.onDispose(
//       () {
//         Logger().d("Disposed - postId : $postId");
//       },
//     );
//     return null;
//   }
//
//   Future<void> updatePost(
//       Post updatedPost, int postId, String title, String content) async {
//     state = state!.copyWith(status: PostWriteStatus.loading);
//     Map<String, dynamic> response =
//         await PostRepository().updateOne(updatedPost);
//     if (response['success'] == true) {
//       state = state!.copyWith(
//         status: PostWriteStatus.success,
//         message: "Post Update Success",
//         updatedPost: updatedPost,
//       );
//     } else {
//       state = state!.copyWith(
//         status: PostWriteStatus.failure,
//         message: "Post Update Failed : ${response['errorMessage']}",
//       );
//     }
//   }
//
//   Future<void> loadPostUpdate(int postId) async {
//     try {
//       // 1. 게시글 상세보기 요청
//       state = state?.copyWith(isLoading: true, error: null);
//       // 2.
//       Map<String, dynamic> response = await PostRepository().getOne(postId);
//       // 3.
//       if (response['success']) {
//         Post updatedPost = Post.fromMap(response['response']);
//         state = state!.copyWith(
//             status: PostWriteStatus.success,
//             message: "Post Update Success",
//             updatedPost: updatedPost);
//       } else {
//         state = state?.copyWith(error: response['errorMessage']);
//       }
//     } catch (e) {}
//   }
//
//   Future<void> refresh(int postId) async {
//     await loadPostUpdate(postId);
//   }
// }
//
// final postUpdateProvider = AutoDisposeNotifierProvider.family<
//     PostUpdateNotifier, PostUpdateModel?, int>(() => PostUpdateNotifier());
