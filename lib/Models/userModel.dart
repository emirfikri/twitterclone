// ignore_for_file: file_names

class UserModel {
  final String username;
  final String email;
  final String uid;
  UserModel({required this.uid, required this.username, required this.email});

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] ?? '',
        email = json['email'] ?? '',
        username = json['username'] ?? '';

  dynamic toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
