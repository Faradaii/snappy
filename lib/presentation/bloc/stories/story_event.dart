part of 'story_bloc.dart';

sealed class StoryEvent {}

class GetAllStoryEvent extends StoryEvent {
  final bool? forceRefresh;
  final int? page;
  final int? size;
  final int? location;

  GetAllStoryEvent({this.forceRefresh, this.page, this.size, this.location});
}
