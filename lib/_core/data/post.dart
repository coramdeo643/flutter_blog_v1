import 'replies.dart';
import 'user.dart';

class Post {
  int id; // Post ID
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int bookmarkCount;
  bool? isBookmark; // 현재 사용자의 북마크 여부?(로그인 상태에 따라 달라진다)
  User user;
  //Replies replies;
  //int? status;
  //String? errorMessage;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.bookmarkCount,
    required this.user,
    //required this.replies,
    this.isBookmark,
  });

  Post.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        content = data['content'],
        createdAt = DateTime.parse(data['createdAt']),
        updatedAt = DateTime.parse(data['updatedAt']),
        bookmarkCount = data['bookmarkCount'],
        user = User.fromMap(data['user']),
        //  replies = data['replies'],
        isBookmark = data['isBookmark'];

  Post copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? bookmarkCount,
    User? user,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookmarkCount: bookmarkCount ?? this.bookmarkCount,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'Post{id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, '
        'bookmarkCount: $bookmarkCount, user: $user, '
        //'replies: $replies, '
        'isBookmark: $isBookmark}';
  }
}
