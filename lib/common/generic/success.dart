import 'package:equatable/equatable.dart';

class Success<T> extends Equatable {
  final String message;
  final T? data;

  const Success({required this.message, this.data});

  @override
  List<Object> get props => [message, data ?? ''];
}
