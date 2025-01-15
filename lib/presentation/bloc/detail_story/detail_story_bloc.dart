import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/domain/usecases/story_get_detail_usecase.dart';

import '../../../common/utils/data_state.dart';
import '../../../domain/entities/story_entity.dart';

part 'detail_story_event.dart';
part 'detail_story_state.dart';

class DetailStoryBloc extends Bloc<DetailStoryEvent, DetailStoryState> {
  final GetDetailStory storyGetDetailUseCase;

  DetailStoryBloc({required this.storyGetDetailUseCase})
    : super(const DetailStoryInitialState()) {
    on<GetDetailStoryEvent>((event, emit) async {
      emit(const DetailStoryLoadingState());
      final result = await storyGetDetailUseCase.execute(event.id);
      result.fold(
        (failure) => emit(DetailStoryErrorState(failure.message)),
        (success) => emit(DetailStorySuccessState(success.data!)),
      );
    });
  }
}
