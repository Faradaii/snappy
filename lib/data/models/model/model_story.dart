import 'package:equatable/equatable.dart';
import 'package:snappy/domain/entities/story_entity.dart';

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

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        photoUrl: json['photoUrl'],
        createdAt: json['createdAt'],
        lat: json['lat'],
        lon: json['lon'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };

    if (lat != null) {
      data['lat'] = lat;
    }
    if (lon != null) {
      data['lon'] = lon;
    }

    return data;
  }

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
