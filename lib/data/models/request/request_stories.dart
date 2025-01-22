import 'package:json_annotation/json_annotation.dart';

part 'request_stories.g.dart';

@JsonSerializable()
class StoriesRequest {
  final int? page;
  final int? size;
  final int? location;

  StoriesRequest({this.page, this.size, this.location});

  Map<String, dynamic> toJson() => _$StoriesRequestToJson(this);
}
