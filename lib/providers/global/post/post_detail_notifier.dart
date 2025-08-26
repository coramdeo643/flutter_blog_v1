// 통신 관련해서 -> UI 갱신 로직
// 통신 요청 -> 로딩 > 성공 / 실패

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../_core/data/post.dart';

class PostDetailModel {
  final Post post;
  final bool isLoading;
  final String? error;

  PostDetailModel({
    required this.post,
    this.isLoading = false,
    this.error,
  });

  PostDetailModel.fromMap(Map<String, dynamic> data)
      : post = Post.fromMap(data),
        isLoading = false,
        error = null;

  // 서버에서 응답 데이터 구조
  // id, title, content, user...
  // JSON 받아서 parse 하는 코드 작성

  // 불변 패턴 사용
  PostDetailModel copyWith({
    Post? post,
    bool? isLoading,
    String? error,
  }) {
    return PostDetailModel(
      post: post ?? this.post,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'PostDetailModel{post: $post, isLoading: $isLoading, error: $error}';
  }
}

class PostDetailNotifier
    extends AutoDisposeFamilyNotifier<PostDetailModel?, int> {
  @override
  PostDetailModel? build(int postId) {
    Logger().d("Detail ID : $postId");
    // 개발 디버깅용 코드
    ref.onDispose(() {
      Logger().d("Disposed postDetailNotifier !!! - postId : $postId");
    });
    // 초기값을 null 선언하는 이유는 아직 통신을 통해서 데이터를 안 불러온 상태
    return null;
  }

  /// 게시글 불러오기 기능 추가
  ///
  /// 게시글 삭제하기 기능 추가
  ///
  /// 게시글 수정은 화면 이동해서 처리
  ///
}

// ver.2.x
final postDetailProvider = AutoDisposeNotifierProvider.family<
    PostDetailNotifier, PostDetailModel?, int>(() => PostDetailNotifier());
