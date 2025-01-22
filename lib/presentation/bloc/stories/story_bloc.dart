import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/domain/usecases/story_get_all_usecase.dart';

import '../../../common/utils/data_state.dart';
import '../../../domain/entities/story_entity.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final GetAllStory storyGetAllUseCase;

  StoryBloc({required this.storyGetAllUseCase}) : super(StoryInitialState()) {
    on<GetAllStoryEvent>((event, emit) async {
      emit(StoryLoadingState(page: state.page ?? 0, size: state.size, listStory: state.listStory));
      final result = await storyGetAllUseCase.execute(
        event.forceRefresh,
        state.page ?? 0,
        state.size,
        event.location,
      );
      print("BLOC STORY ${state.page} - ${state.size} --- story length ${state.listStory?.length}");
      result.fold(
            (failure) => emit(StoryErrorState(failure.message, page: state.page, size: state.size, listStory: state.listStory)),
            (success) {
          final nextPage = success.data!.length < state.size ? null : (state.page ?? 0) + 1;

          success.data!.isEmpty
              ? emit(StoryEmptyState(page: state.page, size: state.size, listStory: state.listStory))
              : emit(StorySuccessState(
            listStory: [...?state.listStory, ...success.data!],
            message: success.message,
            page: nextPage,
            size: state.size,
          ));
        },
      );
    });
  }
}
