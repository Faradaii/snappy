import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snappy/data/models/model/model_story.dart';
import 'package:snappy/data/models/request/request_add_story.dart';
import 'package:snappy/data/models/request/request_login.dart';
import 'package:snappy/data/models/request/request_stories.dart';
import 'package:snappy/data/models/response/response_api_message.dart';
import 'package:snappy/data/models/response/response_stories.dart';
import 'package:snappy/data/models/response/response_story_detail.dart';

import '../models/request/request_register.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryModel>> getStories(StoriesRequest? configRequest);

  Future<StoryModel> getDetailStory(String id);

  Future<String> addStory(AddStoryRequest newStory);

  Future<String> authLogin(LoginRequest loginData);

  Future<String> authRegister(RegisterRequest registerData);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  late final Dio dio;
  late final String baseUrl;

  init() {
    dio = Dio();
    baseUrl = dotenv.env['API_BASE_URL']!;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] =
              'Bearer ${dotenv.env['API_TOKEN']!}';
          return handler.next(options);
        },
      ),
    );
  }

  @override
  Future<String> addStory(AddStoryRequest newStory) async {
    final response = await dio.post(
      '$baseUrl/stories',
      data: newStory.toJson(),
    );
    print(response);

    if (response.statusCode == 200) {
      return ApiMessageResponse.fromJson(jsonDecode(response.data)).message;
    } else {
      throw Exception('Failed to add story');
    }
  }

  @override
  Future<String> authLogin(LoginRequest loginData) async {
    final response = await dio.post('$baseUrl/login', data: loginData.toJson());
    print(response);

    if (response.statusCode == 200) {
      return ApiMessageResponse.fromJson(jsonDecode(response.data)).message;
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<String> authRegister(RegisterRequest registerData) async {
    final response = await dio.post(
      '$baseUrl/register',
      data: registerData.toJson(),
    );
    print(response);

    if (response.statusCode == 200) {
      return ApiMessageResponse.fromJson(jsonDecode(response.data)).message;
    } else {
      throw Exception('Failed to register');
    }
  }

  @override
  Future<StoryModel> getDetailStory(String id) async {
    final response = await dio.get('$baseUrl/stories/$id');
    print(response);

    if (response.statusCode == 200) {
      return StoryDetailResponse.fromJson(jsonDecode(response.data)).story!;
    } else {
      throw Exception('Failed to load story');
    }
  }

  @override
  Future<List<StoryModel>> getStories(StoriesRequest? configRequest) async {
    final response = await dio.get(
      '$baseUrl/stories',
      queryParameters: configRequest?.toJson(),
    );
    print(response);

    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(jsonDecode(response.data)).listStory!;
    } else {
      throw Exception('Failed to load stories');
    }
  }
}
