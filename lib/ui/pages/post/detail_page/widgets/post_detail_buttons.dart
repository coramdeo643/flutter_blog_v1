import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/data/post.dart';
import 'package:flutter_blog/_core/utils/permission_util.dart';
import 'package:flutter_blog/_test_code/record.dart';
import 'package:flutter_blog/providers/global/post/post_detail_notifier.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/providers/global/session_notifier.dart';
import 'package:flutter_blog/ui/pages/post/update_page/post_update_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailButtons extends ConsumerWidget {
  final Post post;
  const PostDetailButtons(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SessionModel sessionModel = ref.read(sessionProvider);
    final currentUser = sessionModel.user;
    bool canEdit = PermissionUtil.canEditPost(currentUser, post);
    bool canDelete = PermissionUtil.canDeletePost(currentUser, post);
    if (carList == false && canDelete == false) {
      return SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () async {
            _handleDeleteBtn(context, ref);
            // await ref
            //     .read(postDetailProvider(post.id).notifier)
            //     .deletePost(post.id);
          },
          icon: const Icon(CupertinoIcons.delete),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => PostUpdatePage(post)));
          },
          icon: const Icon(CupertinoIcons.pen),
        ),
      ],
    );
  } // end of build

  // delete button click event
  void _handleDeleteBtn(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Post Delete"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are you sure to delete?"),
              const SizedBox(height: 8),
              Text(
                'title : ${post.title}',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () async {
                  // Dialog 내리기
                  Navigator.of(context).pop();
                  // Delete Service logic request
                  Map<String, dynamic> result = await ref
                      .read(postDetailProvider(post.id).notifier)
                      .deletePost(post.id);
                  // Result event
                  if (result["success"]) {
                    Navigator.of(context).pop();
                    await ref.read(postListProvider.notifier).fetchPosts();
                    // mounted = true
                    // widget dispose = mounted = false,
                    // 객체는 여전히 존재하지만 위젯 트리에 분리되있는 상태를 말한다
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text("Post Deleted!")));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.orange,
                        content: Text("Post Delete Failed!")));
                  }
                },
                child: Text("Delete"),
                style: TextButton.styleFrom(foregroundColor: Colors.red))
          ],
        );
      },
    );
  }
  // show delete alert dialog
  // delete post
}
