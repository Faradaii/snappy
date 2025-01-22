import 'package:snappy/data/models/model/model_story.dart';
import 'package:snappy/data/models/response/response_api_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_stories.g.dart';

@JsonSerializable()
class StoriesResponse extends ApiMessageResponse {
  final List<StoryModel>? listStory;

  const StoriesResponse({
    required super.error,
    required super.message,
    this.listStory,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) => _$StoriesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoriesResponseToJson(this);

  @override
  List<Object?> get props => [error, message, listStory];
}
