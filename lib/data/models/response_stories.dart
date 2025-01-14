import 'package:snappy/data/models/model_story.dart';
import 'package:snappy/data/models/response_api_message.dart';

class StoriesResponse extends ApiMessageResponse {
  final List<StoryModel>? listStory;

  const StoriesResponse({
    required super.error,
    required super.message,
    this.listStory,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      StoriesResponse(
        error: json['error'],
        message: json['message'],
        listStory:
            json['listStory'] != null
                ? List<StoryModel>.from(
                  json['listStory'].map((v) => StoryModel.fromJson(v)),
                )
                : [],
      );

  @override
  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'listStory': listStory?.map((v) => v.toJson()).toList(),
  };

  @override
  List<Object?> get props => [error, message, listStory];
}
