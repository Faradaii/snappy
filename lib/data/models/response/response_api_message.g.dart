// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_api_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiMessageResponse _$ApiMessageResponseFromJson(Map<String, dynamic> json) =>
    ApiMessageResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ApiMessageResponseToJson(ApiMessageResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
    };
