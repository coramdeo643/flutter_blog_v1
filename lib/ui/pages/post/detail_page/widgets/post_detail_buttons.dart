import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/data/post.dart';
import 'package:flutter_blog/_core/utils/permission_util.dart';
import 'package:flutter_blog/_test_code/record.dart';
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
          onPressed: () async {},
          icon: const Icon(CupertinoIcons.delete),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => PostUpdatePage()));
          },
          icon: const Icon(CupertinoIcons.pen),
        ),
      ],
    );
  }
}
