import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/domain/repositories/story_repository.dart';

import '../../common/generic/failure.dart';

class RegisterAuth {
  final StoryRepository repository;

  RegisterAuth(this.repository);

  Future<Either<Failure, Success<String>>> execute(String name, String email,
      String password) {
    return repository.registerAuth(name, email, password);
  }
}
