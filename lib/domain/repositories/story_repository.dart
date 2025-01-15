import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/domain/entities/story_entity.dart';

import '../../common/generic/failure.dart';

abstract class StoryRepository {
  Future<Either<Failure, Success<String>>> registerAuth(String name,
      String email, String password);

  Future<Either<Failure, Success<String>>> loginAuth(String email,
      String password);

  Future<Either<Failure, Success<String>>> addStory(String description,
      List<int> photo, double? lat, double? lon);

  Future<Either<Failure, Success<List<Story>>>> getStories(int? page, int? size,
      int? location);
  Future<Either<Failure, Success<Story>>> getDetailStory(String id);
}
