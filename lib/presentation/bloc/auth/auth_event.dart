part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthInitEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthRegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}
