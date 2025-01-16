part of 'shared_preference_bloc.dart';

sealed class SharedPreferenceState {
  final DataState dataState;
  final AppLanguage? language;
  final bool? isFirstTime;
  final User? savedUser;
  final String? errorMessage;

  const SharedPreferenceState({
    required this.dataState,
    this.language,
    this.isFirstTime,
    this.savedUser,
    this.errorMessage,
  });

  SharedPreferenceState copyWith({
    DataState? dataState,
    AppLanguage? language,
    bool? isFirstTime,
    User? savedUser,
    String? errorMessage,
  }) {
    if (this is SharedPreferenceInitialState) {
      return SharedPreferenceInitialState();
    } else if (this is SharedPreferenceLoadedState) {
      return SharedPreferenceLoadedState(
        language: language ?? this.language,
        isFirstTime: isFirstTime ?? this.isFirstTime,
        savedUser: savedUser ?? this.savedUser,
      );
    } else if (this is SharedPreferenceErrorState) {
      return SharedPreferenceErrorState(errorMessage ?? this.errorMessage!);
    }
    throw Exception('Invalid state');
  }
}

final class SharedPreferenceInitialState extends SharedPreferenceState {
  const SharedPreferenceInitialState() : super(dataState: DataState.loading);
}

final class SharedPreferenceErrorState extends SharedPreferenceState {
  const SharedPreferenceErrorState(String errorMessage)
    : super(dataState: DataState.error, errorMessage: errorMessage);
}

final class SharedPreferenceLoadedState extends SharedPreferenceState {
  const SharedPreferenceLoadedState(
      {AppLanguage? language, bool? isFirstTime, User? savedUser})
    : super(
        dataState: DataState.success,
        language: language,
        isFirstTime: isFirstTime,
    savedUser: savedUser,
      );
}
