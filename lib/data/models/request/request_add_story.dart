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
}
