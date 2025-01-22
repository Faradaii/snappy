import 'package:snappy/data/models/model/model_story.dart';
import 'package:snappy/data/models/response/response_api_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_story_detail.g.dart';

@JsonSerializable()
class StoryDetailResponse extends ApiMessageResponse {
  final StoryModel? story;

  const StoryDetailResponse({
    required super.error,
    required super.message,
    this.story,
  });

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) => _$StoryDetailResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);

  @override
  List<Object?> get props => [error, message, story];
}
