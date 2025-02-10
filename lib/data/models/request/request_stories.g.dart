// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesRequest _$StoriesRequestFromJson(Map<String, dynamic> json) =>
    StoriesRequest(
      page: (json['page'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
      location: (json['location'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoriesRequestToJson(StoriesRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'location': instance.location,
    };
