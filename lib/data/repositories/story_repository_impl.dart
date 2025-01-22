import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:snappy/common/generic/failure.dart';
import 'package:snappy/common/generic/success.dart';
import 'package:snappy/data/models/request/request_add_story.dart';
import 'package:snappy/data/models/request/request_login.dart';
import 'package:snappy/data/models/request/request_stories.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/domain/repositories/story_repository.dart';

import '../datasources/story_local_datasource.dart';
import '../datasources/story_remote_datasource.dart';
import '../models/request/request_register.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource storyRemoteDataSource;
  final StoryLocalDataSource storyLocalDataSource;

  StoryRepositoryImpl({
    required this.storyLocalDataSource,
    required this.storyRemoteDataSource,
  });

  @override
  Future<Either<Failure, Success<String>>> addStory(
      String description, List<int> photo, double? lat, double? lon) async {
    try {
      final configRequest = AddStoryRequest(
          description: description, photo: photo, lat: lat, lon: lon);
      final result = await storyRemoteDataSource.addStory(configRequest);
      return Right(Success(message: result.message));
    } catch (e) {
      return Left(Failure("Failed to add story"));
    }
  }

  @override
  Future<Either<Failure, Success<Story>>> getDetailStory(String id) async {
    try {
      final localResult = await storyLocalDataSource.getStoryById(id);
      if (localResult != null) {
        return Right(Success(
          message: 'Loaded',
          data: localResult.toEntity(),
        ));
      }
      final result = await storyRemoteDataSource.getDetailStory(id);
      return Right(
          Success(message: result.message, data: result.story?.toEntity()));
    } catch (e) {
      return Left(Failure("Failed to load"));
    }
  }

  @override
  Future<Either<Failure, Success<List<Story>>>> getStories(
      bool? forceRefresh, int? page, int? size, int? location) async {
    try {
      final configRequest =
          StoriesRequest(page: page, size: size, location: location);
      final apiResult = await storyRemoteDataSource.getStories(configRequest);
      if (apiResult.listStory != null) {
        storyLocalDataSource.insertOrUpdateListStory(apiResult.listStory ?? []);
      }
      return Right(Success(
          message: apiResult.message,
          data: apiResult.listStory?.map((e) => e.toEntity()).toList()));
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        final localResult = await storyLocalDataSource.getStories();
        return Right(Success(
          message: 'Load from local',
          data: localResult.map((e) => e.toEntity()).toList(),
        ));
      } else {
        return Left(Failure("Failed to load"));
      }
    }
  }

  @override
  Future<Either<Failure, Success<String>>> loginAuth(
      String email, String password) async {
    try {
      final configRequest = LoginRequest(email: email, password: password);
      final result = await storyRemoteDataSource.authLogin(configRequest);
      return Right(Success(message: result.message));
    } catch (e) {
      return Left(Failure("Failed to login"));
    }
  }

  @override
  Future<Either<Failure, Success<String>>> registerAuth(
      String name, String email, String password) async {
    try {
      final configRequest =
          RegisterRequest(name: name, email: email, password: password);
      final result = await storyRemoteDataSource.authRegister(configRequest);
      return Right(Success(message: result.message));
    } catch (e) {
      return Left(Failure("Failed to register"));
    }
  }
}
