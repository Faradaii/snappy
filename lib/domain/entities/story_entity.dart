import 'package:equatable/equatable.dart';

class Story extends Equatable {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  const Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

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
