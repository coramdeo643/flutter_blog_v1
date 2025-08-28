import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../_core/data/post.dart';

class PostDetailProfile extends StatelessWidget {
  final Post post;
  const PostDetailProfile(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
          title: Text(post.user.username ?? ""),
          leading:
              //Image.network('$baseUrl${post.user.imgUrl}'),
              ClipOval(
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              imageUrl: "$baseUrl${post.user.imgUrl}",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          subtitle: Wrap(
            children: [
              Text("email"),
              const SizedBox(width: mediumGap),
              const Text("·"),
              const SizedBox(width: mediumGap),
              const Text("Written on "),
              Text("${post.createdAt}"),
            ],
          )),
    );
  }
}
