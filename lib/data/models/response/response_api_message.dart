import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_api_message.g.dart';

@JsonSerializable()
class ApiMessageResponse extends Equatable {
  final bool error;
  final String message;

  const ApiMessageResponse({required this.error, required this.message});

  factory ApiMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiMessageResponseToJson(this);

  @override
  List<Object?> get props => [error, message];
}
