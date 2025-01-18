import 'package:dio/dio.dart';

class AddStoryRequest {
  final String description;
  final List<int> photo;
  final double? lat;
  final double? lon;

  AddStoryRequest({
    required this.description,
    required this.photo,
    this.lat,
    this.lon,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'description': description,
      'photo': MultipartFile.fromBytes(photo, filename: '${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg'),
    };

    if (lat != null) {
      data['lat'] = lat;
    }

    if (lon != null) {
      data['lon'] = lon;
    }

    return data;
  }
}
