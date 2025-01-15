import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/domain/usecases/story_get_all_usecase.dart';

import '../../../common/utils/data_state.dart';
import '../../../domain/entities/story_entity.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final GetAllStory storyGetAllUseCase;

  StoryBloc({required this.storyGetAllUseCase})
    : super(const StoryInitialState()) {
    on<GetAllStoryEvent>((event, emit) async {
      emit(const StoryLoadingState());
      final result = await storyGetAllUseCase.execute(
        event.page,
        event.size,
        event.location,
      );
      result.fold(
        (failure) => emit(StoryErrorState(failure.message)),
        (success) =>
            success.data!.isEmpty
                ? emit(const StoryEmptyState())
                : emit(StorySuccessState(success.data!)),
      );
    });
  }
}
