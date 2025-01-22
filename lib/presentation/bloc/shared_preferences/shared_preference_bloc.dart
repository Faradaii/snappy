import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/common/utils/preferences_helper.dart';
import 'package:snappy/domain/entities/user_entity.dart';

import '../../../common/utils/data_state.dart';

part 'shared_preference_event.dart';
part 'shared_preference_state.dart';

class SharedPreferenceBloc
    extends Bloc<SharedPreferenceEvent, SharedPreferenceState> {
  final PreferencesHelper preferencesHelper;

  SharedPreferenceBloc({required this.preferencesHelper})
      : super(SharedPreferenceInitialState()) {
    on<SharedPreferenceInitEvent>((event, emit) async {
      try {
        Locale? language = await preferencesHelper.getLanguage();
        bool isFirstTime = await preferencesHelper.getIsFirstTime();
        User? savedUser = await preferencesHelper.getSavedUser();

        emit(SharedPreferenceLoadedState(
            language: language,
            isFirstTime: isFirstTime,
            savedUser: savedUser));
      } catch (e) {
        emit(SharedPreferenceErrorState("Failed to load shared preferences"));
      }
    });
    on<SharedPreferenceGetLanguageEvent>((event, emit) async {
      try {
        Locale? language = await preferencesHelper.getLanguage();
        emit(SharedPreferenceLoadedState(
          language: language,
          isFirstTime: state.isFirstTime,
          savedUser: state.savedUser,
        ));
      } catch (e) {
        emit(SharedPreferenceErrorState("Failed to load language preferences"));
      }
    });
    on<SharedPreferenceGetIsFirstTimeEvent>((event, emit) async {
      try {
        bool isFirstTime = await preferencesHelper.getIsFirstTime();
        emit(SharedPreferenceLoadedState(
          language: state.language,
          isFirstTime: isFirstTime,
          savedUser: state.savedUser,
        ));
      } catch (e) {
        emit(SharedPreferenceErrorState(
            "Failed to load first time preferences"));
      }
    });
    on<SharedPreferenceSetLanguageEvent>((event, emit) async {
      try {
        await preferencesHelper.setLanguage(event.language);
        emit(SharedPreferenceLoadedState(
          language: event.language,
          isFirstTime: state.isFirstTime,
          savedUser: state.savedUser,
        ));
      } catch (e) {
        emit(SharedPreferenceErrorState("Failed to set shared preferences"));
      }
    });
    on<SharedPreferenceSetIsFirstTimeEvent>((event, emit) async {
      try {
        await preferencesHelper.setFirstTime(false);
        emit(SharedPreferenceLoadedState(
          language: state.language,
          isFirstTime: event.isFirstTime,
          savedUser: state.savedUser,
        ));
      } catch (e) {
        emit(SharedPreferenceErrorState("Failed to set shared preferences"));
      }
    });
    on<SharedPreferenceGetSavedUserEvent>((event, emit) async {
      try {
        User? user =
            await preferencesHelper.getSavedUser().then((value) => value);
        print("SET LANGUAGE: ${state.savedUser}");

        emit(SharedPreferenceLoadedState(
          language: state.language,
          isFirstTime: state.isFirstTime,
          savedUser: user,
        ));
      } catch (e) {
        emit(SharedPreferenceErrorState(
            "Failed to load saved user preferences"));
      }
    });
    on<SharedPreferenceSetSavedUserEvent>((event, emit) async {
      try {
        await preferencesHelper.setSavedUser(event.userEntity);
        emit(SharedPreferenceLoadedState(
            language: state.language,
            isFirstTime: state.isFirstTime,
            savedUser: event.userEntity));
      } catch (e) {
        emit(SharedPreferenceErrorState("Failed to set shared preferences"));
      }
    });
  }
}
