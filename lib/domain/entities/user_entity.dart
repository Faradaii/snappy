import 'package:equatable/equatable.dart';

class User extends Equatable {
  String email;
  String userId;
  String name;
  String token;

  User({
    required this.email,
    required this.userId,
    required this.name,
    required this.token,
  });

  @override
  List<Object?> get props => [email, userId, name, token];
}
