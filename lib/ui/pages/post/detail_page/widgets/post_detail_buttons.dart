import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/data/post.dart';
import 'package:flutter_blog/ui/pages/post/update_page/post_update_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers/global/post/post_list_notifier.dart';
import '../../../../../providers/global/post/post_write_notifier.dart';

class PostDetailButtons extends ConsumerWidget {
  //final Post post;
  const PostDetailButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Post post;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () async {
            // TODO : 게시글 삭제 로직 구현
            // await ref.read(postWriteProvider.notifier).deletePost(post.id);
            // await ref.read(postListProvider.notifier).refreshPosts();
            // Navigator.pushReplacementNamed(context, "/post/list");
          },
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
