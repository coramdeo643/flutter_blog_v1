// User Model Class Design
// API 문서 기준으로 설계해 볼 수 있다.
class User {
  int? id; // API에서 누락될수있기때문에 Nullable
  String? username;
  String? imgUrl; // profile img is optional
  String? accessToken;

  User({
    this.id,
    this.username,
    this.imgUrl,
    this.accessToken,
  });

  // json to Dart convert constructor(Named Constructor)
  // Dart -> json String convert package, map structure convert
  User.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        username = data['username'],
        imgUrl = data['imgUrl'],
        accessToken = data['accessToken'];
  // User() 객체를 생성해주는 코드
  // 디버깅용 문자열 표현
  @override
  String toString() {
    return 'User{id: $id, username: $username, imgUrl: $imgUrl, accessToken: $accessToken}';
  }
}
