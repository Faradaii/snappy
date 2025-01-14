import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/domain/entities/story_entity.dart';

import '../../common/generic/failure.dart';

abstract class StoryRepository {
  Future<Either<Failure, Success<String>>> registerAuth();

  Future<Either<Failure, Success<String>>> loginAuth();

  Future<Either<Failure, Success<String>>> addStory();

  Future<Either<Failure, Success<List<Story>>>> getStories();

  Future<Either<Failure, Success<Story>>> getDetailStory(String id);
}
