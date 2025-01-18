part of 'add_story_bloc.dart';

sealed class AddStoryState {
  final DataState dataState;
  final String? message;

  const AddStoryState({required this.dataState, this.message});
}

final class AddStoryInitialState extends AddStoryState {
  const AddStoryInitialState() : super(dataState: DataState.loading);
}

final class AddStoryLoadingState extends AddStoryState {
  const AddStoryLoadingState() : super(dataState: DataState.loading);
}

final class AddStorySuccessState extends AddStoryState {
  const AddStorySuccessState(String message)
    : super(dataState: DataState.success, message: message);
}

final class AddStoryErrorState extends AddStoryState {
  const AddStoryErrorState(String message)
    : super(dataState: DataState.error, message: message);
}

final class AddStoryImagePickState extends AddStoryState {
  final String? imagePath;

  const AddStoryImagePickState({this.imagePath})
    : super(dataState: DataState.success);
}