import 'package:json_annotation/json_annotation.dart';

part 'request_login.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
