import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ConsumerWidget = StatelessWidget + Riverpod
// ConsumerStatefulWidget = StatefulWidget + Riverpod
// = 로컬 UI 상태 변경이 필요한 경우,
// 여러 컨트롤러 객체가 필요한 경우,
// 애니메이션 사용이 필요한 경우
class PostListBody extends ConsumerStatefulWidget {
  const PostListBody({super.key});

  @override
  ConsumerState<PostListBody> createState() => _PostListBodyState();
}

class _PostListBodyState extends ConsumerState<PostListBody> {
  // ScrollController : 스크롤 위치 감시, 메모리 해제가 필요하다
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    // Provider 초기화
    super.initState();
    _scrollController.addListener(() {
      _onScroll();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 10) {
      if (_isLoading == false) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    PostListModel? model = ref.read(postListProvider);
    if (model == null || model.isLast) {
      return;
    }
    try {
      _isLoading = true;
      await ref.read(postListProvider.notifier).loadMorePosts();
    } finally {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Memory leak 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostListModel? postListModel = ref.watch(postListProvider);
    if (postListModel == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          print("refresh");
          await ref.read(postListProvider.notifier).refreshPosts();
        },
        child: ListView.separated(
          controller: _scrollController,
          itemCount: postListModel.posts.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PostDetailPage()));
              },
              child: PostListItem(postListModel.posts[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      );
    }
  }
}
