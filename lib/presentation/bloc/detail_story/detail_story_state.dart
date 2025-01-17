part of 'detail_story_bloc.dart';

sealed class DetailStoryState {
  final DataState dataState;
  final String? message;

  const DetailStoryState({required this.dataState, this.message});
}

final class DetailStoryInitialState extends DetailStoryState {
  const DetailStoryInitialState() : super(dataState: DataState.loading);
}

final class DetailStoryLoadingState extends DetailStoryState {
  const DetailStoryLoadingState() : super(dataState: DataState.loading);
}

final class DetailStorySuccessState extends DetailStoryState {
  final Story detailStory;

  const DetailStorySuccessState({required this.detailStory, super.message})
    : super(dataState: DataState.success);
}

final class DetailStoryEmptyState extends DetailStoryState {
  const DetailStoryEmptyState() : super(dataState: DataState.empty);
}

final class DetailStoryErrorState extends DetailStoryState {
  const DetailStoryErrorState(String message)
    : super(dataState: DataState.error, message: message);
}
