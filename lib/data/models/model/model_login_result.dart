import '../../../domain/entities/user_entity.dart';

class LoginResult {
  String userId;
  String name;
  String token;
  String? email;

  LoginResult(
      {required this.userId,
      required this.name,
      required this.token,
      this.email});

  factory LoginResult.fromJson(
          {required Map<String, dynamic> json, String? email}) =>
      LoginResult(
        userId: json['userId'],
        name: json['name'],
        token: json['token'],
        email: email ?? json['email'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'token': token,
        'email': email ?? '',
      };

  User toEntity() {
    return User(email: email ?? '', userId: userId, name: name, token: token);
  }
}
