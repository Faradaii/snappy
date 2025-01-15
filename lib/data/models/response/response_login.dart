import 'package:snappy/data/models/response/response_api_message.dart';

import '../model/model_login_result.dart';

class LoginResponse extends ApiMessageResponse {
  final LoginResult? loginResult;

  const LoginResponse({
    required super.error,
    required super.message,
    this.loginResult,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    error: json['error'],
    message: json['message'],
    loginResult:
        json['loginResult'] != null
            ? LoginResult.fromJson(json: json['loginResult'])
            : null,
  );

  @override
  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'loginResult': loginResult?.toJson(),
  };

  @override
  List<Object?> get props => [error, message, loginResult];
}
