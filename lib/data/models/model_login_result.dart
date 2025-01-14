import '../../domain/entities/user_entity.dart';

class LoginResult {
  String userId;
  String name;
  String token;

  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
    userId: json['userId'],
    name: json['name'],
    token: json['token'],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'token': token,
  };

  User toEntity() {
    return User(email: '', userId: userId, name: name, token: token);
  }
}
