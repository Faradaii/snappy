import 'package:equatable/equatable.dart';

class ApiMessageResponse extends Equatable {
  final bool error;
  final String message;

  const ApiMessageResponse({required this.error, required this.message});

  factory ApiMessageResponse.fromJson(Map<String, dynamic> json) =>
      ApiMessageResponse(error: json['error'], message: json['message']);

  Map<String, dynamic> toJson() => {'error': error, 'message': message};

  @override
  List<Object?> get props => [error, message];
}
