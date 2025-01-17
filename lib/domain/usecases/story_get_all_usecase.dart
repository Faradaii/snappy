import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/domain/repositories/story_repository.dart';

import '../../common/generic/failure.dart';

class GetAllStory {
  final StoryRepository repository;

  GetAllStory(this.repository);

  Future<Either<Failure, Success<List<Story>>>> execute(bool? forceRefresh,
      int? page, int? size,
      int? location) {
    return repository.getStories(forceRefresh, page, size, location);
  }
}
