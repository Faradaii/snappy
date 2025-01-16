import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/common/constant/app_constant.dart';
import 'package:snappy/common/utils/preferences_helper.dart';

import '../../../common/utils/data_state.dart';

part 'shared_preference_event.dart';
part 'shared_preference_state.dart';

class SharedPreferenceBloc
    extends Bloc<SharedPreferenceEvent, SharedPreferenceState> {
  final PreferencesHelper preferencesHelper;

  SharedPreferenceBloc({required this.preferencesHelper})
    : super(SharedPreferenceInitialState()) {
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
  }
}
