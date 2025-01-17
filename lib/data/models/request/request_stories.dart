class StoriesRequest {
  final int? page;
  final int? size;
  final int? location;

  StoriesRequest({this.page, this.size, this.location});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (page != null) data['page'] = page;
    if (size != null) data['size'] = size;
    if (location != null) data['location'] = location;
    return data;
  }
}
