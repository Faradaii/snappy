part of 'detail_story_bloc.dart';

sealed class DetailStoryState {
  final DataState dataState;
  final String? errorMessage;

  const DetailStoryState({required this.dataState, this.errorMessage});
}

final class DetailStoryInitialState extends DetailStoryState {
  const DetailStoryInitialState() : super(dataState: DataState.loading);
}

final class DetailStoryLoadingState extends DetailStoryState {
  const DetailStoryLoadingState() : super(dataState: DataState.loading);
}

final class DetailStorySuccessState extends DetailStoryState {
  final Story detailStory;

  const DetailStorySuccessState(this.detailStory)
    : super(dataState: DataState.success);
}

final class DetailStoryEmptyState extends DetailStoryState {
  const DetailStoryEmptyState() : super(dataState: DataState.empty);
}

final class DetailStoryErrorState extends DetailStoryState {
  const DetailStoryErrorState(String errorMessage)
    : super(dataState: DataState.error, errorMessage: errorMessage);
}
