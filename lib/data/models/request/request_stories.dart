class StoriesRequest {
  final int? page;
  final int? size;
  final int? location;

  StoriesRequest({this.page, this.size, this.location});

  Map<String, dynamic> toJson() => {
    'page': page,
    'size': size,
    'location': location,
  };
}
