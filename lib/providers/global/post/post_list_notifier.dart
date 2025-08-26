// 1. 게시글 목록에 대한 데이터를 설계 하자.
import 'package:flutter_blog/_core/data/models/repository/post_repository.dart';
import 'package:flutter_blog/_core/utils/exception_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../_core/data/post.dart';

class PostListModel {
  bool isFirst;
  bool isLast;
  int pageNumber; // Current Page Number (from 0)
  int size; // Number of Posts in a page
  int totalPage; // Total Page Number
  List<Post> posts; // Posts data

  PostListModel(
    this.isFirst,
    this.isLast,
    this.pageNumber,
    this.size,
    this.totalPage,
    this.posts,
  );

  // Named Constructor, member variable, init keyword !!!
  PostListModel.fromMap(Map<String, dynamic> data)
      : isFirst = data["isFirst"],
        isLast = data["isLast"],
        pageNumber = data["pageNumber"],
        size = data["size"],
        totalPage = data["totalPage"],
        posts = (data["posts"] as List).map((e) => Post.fromMap(e)).toList() {}

  PostListModel copyWith({
    bool? isFirst,
    bool? isLast,
    int? pageNumber,
    int? size,
    int? totalPage,
    List<Post>? posts,
  }) {
    return PostListModel(
      isFirst ?? this.isFirst,
      isLast ?? this.isLast,
      pageNumber ?? this.pageNumber,
      size ?? this.size,
      totalPage ?? this.totalPage,
      posts ?? this.posts,
    );
  }

  @override
  String toString() {
    return 'PostListModel{isFirst: $isFirst, isLast: $isLast, pageNumber: $pageNumber, size: $size, totalPage: $totalPage, posts: $posts}';
  }
// 서버 응답 데이터를 PostListModel 객체로 변환하는 생성자
} // end of PostListModel class

class PostListNotifier extends Notifier<PostListModel?> {
  @override
  PostListModel? build() {
    // 창고 데이터 초기 모델은 항상 > 통신 요청 이후에 결정이 된다
    // TODO 초기화 메서드 추가하기 (통신요청)
    fetchPosts();
    return null;
  }

  //창고 메뉴얼 운영지침 - Business Logic
  // 1. fetchPosts : 게시글 목록 가져오는 로직
  Future<Map<String, dynamic>> fetchPosts({int page = 0}) async {
    Map<String, dynamic> body = await PostRepository().getList(page: page);
    if (body["success"]) {
      // 서버에서 정상적으로 데이터를 내려준다면 JSON 데이터를 PostListModel로 Parse 처리
      PostListModel postListModel = PostListModel.fromMap(body["response"]);
      state = postListModel;
      return {"success": true};
    } else {
      // 서버에서 내려준 에러 메시지를 사용자에게 보여줘
      ExceptionHandler.handleException(
          body["errorMessage"], StackTrace.current);
      return {"success": false};
    }
  }

// 2. RefreshPostList : 목록 새로고침 로직
  Future<Map<String, dynamic>> refreshPosts() async {
    Map<String, dynamic> body = await PostRepository().getList(page: 0);
    if (body["success"]) {
      PostListModel postListModel = PostListModel.fromMap(body["response"]);
      state = postListModel;
      return {"success": true};
    } else {
      ExceptionHandler.handleException(
          body["errorMessage"], StackTrace.current);
      return {"success": false};
    }
  }

// 3. loadMorePosts : 페이지 처리, 추가 데이터 요청
  Future<Map<String, dynamic>> loadMorePosts() async {
    int nextPage = state!.pageNumber + 1;
    Map<String, dynamic> body = await PostRepository().getList(page: nextPage);
    if (body["success"]) {
      PostListModel newPostListModel = PostListModel.fromMap(body["response"]);
      List<Post> newPosts = [...state!.posts, ...newPostListModel.posts];
      state = newPostListModel.copyWith(posts: newPosts);
      return {"success": true};
    } else {
      ExceptionHandler.handleException(
          body["errorMessage"], StackTrace.current);
      return {"success": false};
    }
  }

  // 게시글 목록 새로고침 기능 추가
  Future<void> refreshAfterWriter() async {
    Logger().d("게시글 작성 후 목록 새로고침 시작");
    await fetchPosts(page: 0);
  }

  //
}

final postListProvider = NotifierProvider<PostListNotifier, PostListModel?>(
    () => PostListNotifier());
