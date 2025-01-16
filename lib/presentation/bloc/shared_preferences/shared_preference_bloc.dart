import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/common/constant/app_constant.dart';
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
        AppLanguage? language = await preferencesHelper.getLanguage();
        bool isFirstTime = await preferencesHelper.getIsFirstTime();
        User? savedUser = await preferencesHelper.getSavedUser();
        emit(SharedPreferenceLoadedState(language: language,
            isFirstTime: isFirstTime,
            savedUser: savedUser));
      } catch (e) {
        emit(SharedPreferenceErrorState(e.toString()));
      }
    });
    on<SharedPreferenceGetLanguageEvent>((event, emit) async {
      try {
        AppLanguage? language = await preferencesHelper.getLanguage();
        emit(SharedPreferenceLoadedState(language: language));
      } catch (e) {
        emit(SharedPreferenceErrorState(e.toString()));
      }
    });
    on<SharedPreferenceGetIsFirstTimeEvent>((event, emit) async {
      try {
        bool isFirstTime = await preferencesHelper.getIsFirstTime();
        emit(SharedPreferenceLoadedState(isFirstTime: isFirstTime));
      } catch (e) {
        emit(SharedPreferenceErrorState(e.toString()));
      }
    });
    on<SharedPreferenceSetLanguageEvent>((event, emit) async {
      try {
        await preferencesHelper.setLanguage(event.language);
        emit(SharedPreferenceLoadedState(language: event.language));
      } catch (e) {
        emit(SharedPreferenceErrorState(e.toString()));
      }
    });
    on<SharedPreferenceSetIsFirstTimeEvent>((event, emit) async {
      try {
        await preferencesHelper.setFirstTime(false);
        emit(SharedPreferenceLoadedState(isFirstTime: false));
      } catch (e) {
        emit(SharedPreferenceErrorState(e.toString()));
      }
    });
    on<SharedPreferenceGetSavedUserEvent>((event, emit) async {
      try {
        User? user = await preferencesHelper.getSavedUser().then((
            value) => value);
        emit(SharedPreferenceLoadedState(savedUser: user));
      } catch (e) {
        emit(SharedPreferenceErrorState(e.toString()));
      }
    });
    on<SharedPreferenceSetSavedUserEvent>((event, emit) async {
      try {
        await preferencesHelper.setSavedUser(event.userEntity);
        emit(SharedPreferenceLoadedState(savedUser: event.userEntity));
      } catch (e) {
        emit(SharedPreferenceErrorState(e.toString()));
      }
    });
  }
}
