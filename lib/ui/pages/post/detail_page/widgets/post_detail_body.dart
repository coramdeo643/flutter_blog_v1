import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/permission_util.dart';
import 'package:flutter_blog/providers/global/post/post_detail_notifier.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_buttons.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_content.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_profile.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ConsumerStaefulWidget
// 생명주기 제어, initState 메서드 초기 데이터 필요
// 중복로딩 방지 initState는 단 한번만 호출됨
// 타이밍 제어 : 안전한 provider 에 접근 가능하도록 설계
class PostDetailBody extends ConsumerStatefulWidget {
  final int postId;
  const PostDetailBody(this.postId, {Key? key}) : super(key: key);

  @override
  ConsumerState<PostDetailBody> createState() => _PostDetailBodyState();
}

class _PostDetailBodyState extends ConsumerState<PostDetailBody> {
  // 로딩 상태 여부 플래그 변수
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    /*
     addPostFrameCallback 사용하는 이유?
     1. 안전성 : build 메서드 완료 수 실행 보장
     2. 동기화 : Flutter 렌더링 사이클과 맞춤
     3. Provider 접근 : ref 사용이 안정한 시점에 호출
     */

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  } // end of initState

  void _loadInitialData() {
    if (_isInit == false) {
      _isInit = true;
      ref
          .read(postDetailProvider(widget.postId).notifier)
          .loadPostDetail(widget.postId);
    } else {}
  }

  // 통신 통해서 값 가져오고 그리고 나서 렌더링처리
  @override
  Widget build(BuildContext context) {
    final PostDetailModel? model = ref.watch(postDetailProvider(widget.postId));
    // 1. 초기상태 또는 로딩 중(데이터가 없는 상태)
    if (model == null) {
      return Center(child: CircularProgressIndicator());
    }
    // 2. Error status (Networkd error / server error(500) / Not-Authorized...)
    if (model.error != null) {
      return Container(child: Text("Communication Error - ${model.error}"));
    }
    // 3. 정상 통신
    return RefreshIndicator(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            PostDetailTitle(model.post.title),
            const SizedBox(height: largeGap),
            PostDetailProfile(model.post),
            // Authorization check to delete post
            PostDetailButtons(model.post),
            Divider(),
            const SizedBox(height: largeGap),
            PostDetailContent(model.post.content),
            const SizedBox(height: largeGap),
          ],
        ),
      ),
      onRefresh: () async {
        await ref
            .read(postDetailProvider(widget.postId).notifier)
            .refresh(widget.postId);
      },
    );
  }
}
