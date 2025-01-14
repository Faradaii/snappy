import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/domain/repositories/story_repository.dart';

import '../../common/generic/failure.dart';

class AddStory {
  final StoryRepository repository;

  AddStory(this.repository);

  Future<Either<Failure, Success<String>>> execute() {
    return repository.addStory();
  }
}
