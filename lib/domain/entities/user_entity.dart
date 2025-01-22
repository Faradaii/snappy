import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String userId;
  final String name;
  final String token;

  const User({
    required this.email,
    required this.userId,
    required this.name,
    required this.token,
  });

  @override
  List<Object?> get props => [email, userId, name, token];
}
