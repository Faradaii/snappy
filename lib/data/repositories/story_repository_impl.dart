import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/failure.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/domain/repositories/story_repository.dart';

import '../datasources/story_remote_datasource.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource storyRemoteDataSource;

  StoryRepositoryImpl({
    required this.storyRemoteDataSource,
  });

  @override
  Future<Either<Failure, Success<String>>> addStory() {
    // TODO: implement addStory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success<Story>>> getDetailStory(String id) {
    // TODO: implement getDetailStory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success<List<Story>>>> getStories() {
    // TODO: implement getStories
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success<String>>> loginAuth() {
    // TODO: implement loginAuth
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success<String>>> registerAuth() {
    // TODO: implement registerAuth
    throw UnimplementedError();
  }

}