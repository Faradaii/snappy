import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/domain/repositories/story_repository.dart';

import '../../common/generic/failure.dart';

class LoginAuth {
  final StoryRepository repository;

  LoginAuth(this.repository);

  Future<Either<Failure, Success<String>>> execute(String email,
      String password) {
    return repository.loginAuth(email, password);
  }
}
