part of 'story_bloc.dart';

sealed class StoryEvent {}

class GetAllStoryEvent extends StoryEvent {
  final int? page;
  final int? size;
  final int? location;

  GetAllStoryEvent({this.page, this.size, this.location});
}
