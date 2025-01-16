part of 'shared_preference_bloc.dart';

sealed class SharedPreferenceEvent {}

class SharedPreferenceGetLanguageEvent extends SharedPreferenceEvent {}

class SharedPreferenceSetLanguageEvent extends SharedPreferenceEvent {
  final AppLanguage language;

  SharedPreferenceSetLanguageEvent(this.language);
}

class SharedPreferenceGetIsFirstTimeEvent extends SharedPreferenceEvent {}

class SharedPreferenceSetIsFirstTimeEvent extends SharedPreferenceEvent {
  final bool isFirstTime;

  SharedPreferenceSetIsFirstTimeEvent(this.isFirstTime);
}
