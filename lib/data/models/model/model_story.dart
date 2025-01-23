import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:snappy/domain/entities/story_entity.dart';

part 'model_story.g.dart';

@JsonSerializable()
class StoryModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double? lat;
  final double? lon;

  const StoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  Story toEntity() {
    return Story(
      id: id,
      name: name,
      description: description,
      photoUrl: photoUrl,
      createdAt: DateTime.parse(createdAt),
      lat: lat,
      lon: lon,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        photoUrl,
        createdAt,
        lat,
        lon,
      ];
}
