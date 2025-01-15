part of 'story_bloc.dart';

sealed class StoryState {
  final DataState dataState;
  final String? errorMessage;

  const StoryState({required this.dataState, this.errorMessage});
}

final class StoryInitialState extends StoryState {
  const StoryInitialState() : super(dataState: DataState.loading);
}

final class StoryLoadingState extends StoryState {
  const StoryLoadingState() : super(dataState: DataState.loading);
}

final class StorySuccessState extends StoryState {
  final List<Story> listStory;

  const StorySuccessState(this.listStory) : super(dataState: DataState.success);
}

final class StoryEmptyState extends StoryState {
  const StoryEmptyState() : super(dataState: DataState.empty);
}

final class StoryErrorState extends StoryState {
  const StoryErrorState(String errorMessage)
    : super(dataState: DataState.error, errorMessage: errorMessage);
}
