part of 'auth_bloc.dart';

sealed class AuthState {
  final DataState dataState;
  final String? message;

  const AuthState({required this.dataState, this.message});
}

class AuthInitialState extends AuthState {
  const AuthInitialState() : super(dataState: DataState.loading);
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState() : super(dataState: DataState.loading);
}

class AuthLoginSuccessState extends AuthState {
  const AuthLoginSuccessState(String message)
      : super(dataState: DataState.success, message: message);
}

class AuthRegisterSuccessState extends AuthState {
  const AuthRegisterSuccessState(String message)
      : super(dataState: DataState.success, message: message);
}

class AuthErrorState extends AuthState {
  const AuthErrorState(String message)
      : super(dataState: DataState.error, message: message);
}
