// 권한 관리 전용 유틸리티 클래스
import '../data/post.dart';
import '../data/user.dart';

class PermissionUtil {
  static bool canEditPost(User? currentUser, Post post) {
    // 권한 로직 설계
    // 1. Login Check?
    if (currentUser == null) {
      return false;
    }
    // 2. 게시글 작성자와 현재 사용자 ID 비교
    bool isOwner = currentUser.id == post.user.id;
    // 3. 관리자 권한 체크(옵션)
    //bool isAdmin = currentUser.role == 'ADMIN';
    return isOwner;
  }

  // 게시글 삭제 권한 확인
  static bool canDeletePost(User? currentUser, Post post) {
    // 삭제 권한에서 시간을 추가하고 싶다면?
    // 즉, 24시간 이후에는 삭제를 못한다??
    // DateTime createdAt = post.createdAt;
    // Duration difference = DateTime.now().difference(createdAt);
    // difference.inHours < 24;
    return canEditPost(currentUser, post);
  }

  // String action = "수정, 삭제, 댓글 작성 등"
  static String getNoPermissionMessage(String action) {
    return "There is no permission to $action";
  }
}
