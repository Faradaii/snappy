part of 'add_story_bloc.dart';

sealed class AddStoryEvent {}

class AddStorySubmitEvent extends AddStoryEvent {
  final String description;
  final List<int> photo;
  final double? lat;
  final double? lon;

  AddStorySubmitEvent({
    required this.description,
    required this.photo,
    this.lat,
    this.lon,
  });
}
