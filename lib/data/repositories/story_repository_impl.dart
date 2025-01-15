import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/failure.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/data/models/request/request_add_story.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/domain/repositories/story_repository.dart';

import '../datasources/story_local_datasource.dart';
import '../datasources/story_remote_datasource.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource storyRemoteDataSource;
  final StoryLocalDataSource storyLocalDataSource;

  StoryRepositoryImpl({
    required this.storyLocalDataSource,
    required this.storyRemoteDataSource,
  });

  @override
  Future<Either<Failure, Success<String>>> addStory(String description,
      List<int> photo, double? lat, double? lon) async {
    try {
      final newStory = AddStoryRequest(
          description: description, photo: photo, lat: lat, lon: lon);
      final result = await storyRemoteDataSource.addStory(newStory);
      return Right(Success(message: result));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success<Story>>> getDetailStory(String id) {
    // TODO: implement getDetailStory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success<List<Story>>>> getStories(int? page, int? size,
      int? location) {
    // TODO: implement getStories
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success<String>>> loginAuth(String email,
      String password) {
    // TODO: implement loginAuth
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success<String>>> registerAuth(String name,
      String email, String password) {
    // TODO: implement registerAuth
    throw UnimplementedError();
  }

}