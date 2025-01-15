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
  Future<Either<Failure, Success<String>>> addStory(String description,
      List<int> photo,
      double? lat,
      double? lon) async {
    try {
      final configRequest = AddStoryRequest(
          description: description, photo: photo, lat: lat, lon: lon);
      final result = await storyRemoteDataSource.addStory(configRequest);
      return Right(Success(message: result.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success<Story>>> getDetailStory(String id) async {
    try {
      final result = await storyRemoteDataSource.getDetailStory(id);
      return Right(
          Success(message: result.message, data: result.story?.toEntity()));
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        try {
          final result = await storyLocalDataSource.getStoryById(id);
          return Right(Success(
            message: 'No internet connection',
            data: result?.toEntity(),
          ));
        } catch (localError) {
          return Left(Failure(
              'Failed to retrieve local data: ${localError.toString()}'));
        }
      } else {
        return Left(Failure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Success<List<Story>>>> getStories(int? page,
      int? size,
      int? location) async {
    try {
      final configRequest = StoriesRequest(
          page: page, size: size, location: location);
      final result = await storyRemoteDataSource.getStories(configRequest);
      if (result.listStory != null) storyLocalDataSource
          .insertOrUpdateListStory(result.listStory ?? []);
      return Right(Success(message: result.message,
          data: result.listStory?.map((e) => e.toEntity()).toList()));
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        try {
          final result = await storyLocalDataSource.getStories();
          return Right(Success(
            message: 'No internet connection',
            data: result.map((e) => e.toEntity()).toList(),
          ));
        } catch (localError) {
          return Left(Failure(
              'Failed to retrieve local data: ${localError.toString()}'));
        }
      } else {
        return Left(Failure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Success<String>>> loginAuth(String email,
      String password) async {
    try {
      final configRequest = LoginRequest(email: email, password: password);
      final result = await storyRemoteDataSource.authLogin(configRequest);
      return Right(Success(message: result.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success<String>>> registerAuth(String name,
      String email,
      String password) async {
    try {
      final configRequest = RegisterRequest(
          name: name, email: email, password: password);
      final result = await storyRemoteDataSource.authRegister(configRequest);
      return Right(Success(message: result.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}