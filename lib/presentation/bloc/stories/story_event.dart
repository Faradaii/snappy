part of 'story_bloc.dart';

sealed class StoryEvent {}

class GetAllStoryEvent extends StoryEvent {
  final bool? forceRefresh;
  int? page = 1;
  int? size = 10;
  final int? location;

  GetAllStoryEvent({this.forceRefresh, this.page, this.size, this.location});
}
