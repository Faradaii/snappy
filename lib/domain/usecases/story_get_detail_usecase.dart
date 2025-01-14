import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/domain/repositories/story_repository.dart';

import '../../common/generic/failure.dart';

class GetDetailStory {
  final StoryRepository repository;

  GetDetailStory(this.repository);

  Future<Either<Failure, Success<Story>>> execute(String id) {
    return repository.getDetailStory(id);
  }
}
