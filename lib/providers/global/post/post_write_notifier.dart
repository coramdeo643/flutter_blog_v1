// 게시글 작성 진행 상태를 나타내는 열거형
import 'package:flutter_blog/_core/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/data/post.dart';

enum PostWriteStatus {
  initial, // 초기 상태(아무것도하지않은)
  loading, // 작성중(서버통신중)
  success, // 게시글 작성 성공
  failure, // 게시글 작성 실패
}

// 게시글 작성 상태를 설계(창고데이터)
class PostWriteModel {
  final PostWriteStatus status; // 현재 게시글 작성 상태
  final String? message; // 사용자에게 보여줄 메세지
  final Post? createdPost;

  PostWriteModel({
    this.status = PostWriteStatus.initial,
    this.message,
    this.createdPost,
  }); // 작성 성공시 생성된 게시글

  // 불변성 패턴
  PostWriteModel copyWith({
    PostWriteStatus? status,
    String? message,
    Post? createdPost,
  }) {
    return PostWriteModel(
      status: status ?? this.status,
      message: message ?? this.message,
      createdPost: createdPost ?? this.createdPost,
    );
  }

  @override
  String toString() {
    return 'PostWriteModel{status: $status, message: $message, createdPost: $createdPost}';
  }
} // end of PostWriteModel

// 창고 메뉴얼 설계
class PostWriteNotifier extends Notifier<PostWriteModel> {
  @override
  PostWriteModel build() {
    return PostWriteModel();
  }

  Future<void> writePost(String title, String content) async {
    // 기본적으로 try.. 사용해야 한다(서버가 불량인 경우를 위해)
    // 생략...
    // 중복 클릭 방지를 위해 상태변경을 한다.
    state = state.copyWith(status: PostWriteStatus.loading);
    // // UI 단에서 loading 상태라면 VoidCallback 값을 null 처리하면 비활성화 버튼으로 변경이 된다.
    // Map<String, dynamic> response =
    //     await PostRepository().write(title, content);
    // if (response['success'] == true) {
    //   Post createdPost = Post.fromMap(response['response']);
    //   state = state.copyWith(
    //     status: PostWriteStatus.success,
    //     message: "Post Write Success",
    //     createdPost: createdPost,
    //   );
    // } else {
    //   state = state.copyWith(
    //     status: PostWriteStatus.failure,
    //     message: "Post Write Failed : ${response['errorMessage']}",
    //   );
    // }
  }
} // end of notifier

final postWriteProivder = NotifierProvider<PostWriteNotifier, PostWriteModel>(
    () => PostWriteNotifier());
