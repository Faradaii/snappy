import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/domain/usecases/auth_login_usecase.dart';
import 'package:snappy/domain/usecases/auth_register_usecase.dart';

import '../../../common/utils/data_state.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginAuth authLoginUseCase;
  final RegisterAuth authRegisterUseCase;

  AuthBloc({required this.authLoginUseCase, required this.authRegisterUseCase})
    : super(AuthInitialState()) {
    on<AuthInitEvent>((event, emit) => emit(const AuthInitialState()));

    on<AuthLoginEvent>((event, emit) async {
      emit(const AuthLoadingState());
      final result = await authLoginUseCase.execute(
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(AuthErrorState(failure.message)),
        (success) => emit(AuthLoginSuccessState(success.message)),
      );
    });

    on<AuthRegisterEvent>((event, emit) async {
      emit(const AuthLoadingState());
      final result = await authRegisterUseCase.execute(
        event.name,
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(AuthErrorState(failure.message)),
        (success) => emit(AuthRegisterSuccessState(success.message)),
      );
    });
  }
}
