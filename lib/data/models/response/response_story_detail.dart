import 'package:snappy/data/models/model/model_story.dart';
import 'package:snappy/data/models/response/response_api_message.dart';

class StoryDetailResponse extends ApiMessageResponse {
  final StoryModel? story;

  const StoryDetailResponse({
    required super.error,
    required super.message,
    this.story,
  });

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      StoryDetailResponse(
        error: json['error'],
        message: json['message'],
        story:
            json['story'] != null ? StoryModel.fromJson(json['story']) : null,
      );

  @override
  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'story': story?.toJson(),
      };

  @override
  List<Object?> get props => [error, message, story];
}
