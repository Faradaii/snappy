part of 'story_bloc.dart';

sealed class StoryState {
  final DataState dataState;
  final List<Story>? listStory;
  final String? message;
  final int? page;
  final int size;

  const StoryState(
      {required this.dataState,
      this.listStory,
      this.message,
      this.page,
      required this.size});
}

final class StoryInitialState extends StoryState {
  StoryInitialState()
      : super(dataState: DataState.loading, page: 0, size: 5, listStory: []);
}

final class StoryLoadingState extends StoryState {
  StoryLoadingState({super.page, required super.size, super.listStory})
      : super(dataState: DataState.loading);
}

final class StorySuccessState extends StoryState {
  StorySuccessState(
      {super.listStory, super.message, super.page, required super.size})
      : super(dataState: DataState.success);
}

final class StoryEmptyState extends StoryState {
  StoryEmptyState({super.page, required super.size, super.listStory})
      : super(dataState: DataState.empty);
}

final class StoryErrorState extends StoryState {
  StoryErrorState(String message,
      {super.page, required super.size, super.listStory})
      : super(dataState: DataState.error, message: message);
}
