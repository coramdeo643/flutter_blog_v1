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

  @override
  void initState() {
    // Provider 초기화
    super.initState();
  }

  @override
  void dispose() {
    // Memory leak 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    PostListModel? postListModel = ref.watch(postListProvider);
    if (postListModel == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.separated(
        itemCount: postListModel.posts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PostDetailPage()));
            },
            child: PostListItem(postListModel.posts[index]),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    }
  }
}
