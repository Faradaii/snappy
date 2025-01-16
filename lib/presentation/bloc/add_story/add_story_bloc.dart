import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/domain/usecases/story_add_usecase.dart';

import '../../../common/utils/data_state.dart';

part 'add_story_event.dart';
part 'add_story_state.dart';

class AddStoryBloc extends Bloc<AddStoryEvent, AddStoryState> {
  final AddStory addStoryUseCase;

  AddStoryBloc({required this.addStoryUseCase})
    : super(AddStoryInitialState()) {
    on<AddStorySubmitEvent>((event, emit) async {
      emit(const AddStoryLoadingState());
      final result = await addStoryUseCase.execute(
        event.description,
        event.photo,
        event.lat,
        event.lon,
      );
      result.fold(
        (failure) => emit(AddStoryErrorState(failure.message)),
        (success) => emit(AddStorySuccessState(success.message)),
      );
    });
  }
}
