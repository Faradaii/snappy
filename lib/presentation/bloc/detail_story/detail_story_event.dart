part of 'detail_story_bloc.dart';

sealed class DetailStoryEvent {}

class GetDetailStoryEvent extends DetailStoryEvent {
  final String id;

  GetDetailStoryEvent(this.id);
}
