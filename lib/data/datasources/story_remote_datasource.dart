import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snappy/data/models/model/model_login_result.dart';
import 'package:snappy/data/models/model/model_story.dart';
import 'package:snappy/data/models/request/request_add_story.dart';
import 'package:snappy/data/models/request/request_login.dart';
import 'package:snappy/data/models/request/request_stories.dart';
import 'package:snappy/data/models/response/response_api_message.dart';
import 'package:snappy/data/models/response/response_stories.dart';
import 'package:snappy/data/models/response/response_story_detail.dart';

import '../../common/utils/preferences_helper.dart';
import '../models/request/request_register.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryModel>> getStories(StoriesRequest? configRequest);
  Future<StoryModel> getDetailStory(String id);
  Future<String> addStory(AddStoryRequest newStory);
  Future<String> authLogin(LoginRequest loginData);
  Future<String> authRegister(RegisterRequest registerData);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final Dio dio;
  final PreferencesHelper preferencesHelper;
  late final String baseUrl;
  late final String token;

  StoryRemoteDataSourceImpl({
    required this.dio, required this.preferencesHelper,
  }) {
    init();
  }

  init() async {
    baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.isEmpty) {
      throw Exception('API_BASE_URL is not defined in the environment file');
    } else {
      dio.options.baseUrl = baseUrl;
    }

    token = await preferencesHelper.getToken().then((value) => value ?? '');

    if (!dio.interceptors.any((i) => i is InterceptorsWrapper)) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] = 'Bearer $token';
            return handler.next(options);
          },
          onError: (e, handler) async {
            throw Exception(e);
          },
        ),
      );
    }
  }

  @override
  Future<String> addStory(AddStoryRequest newStory) async {
    final response = await dio.post(
      '/stories',
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
    final response = await dio.post('/login', data: loginData.toJson());
    print(response);

    if (response.statusCode == 200) {
      LoginResult loginResult = LoginResult.fromJson(
          email: loginData.email, json: response.data);
      await preferencesHelper.setSavedUser(loginResult);

      return ApiMessageResponse.fromJson(jsonDecode(response.data)).message;
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<String> authRegister(RegisterRequest registerData) async {
    final response = await dio.post(
      '/register',
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
    final response = await dio.get('/stories/$id');
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
      '/stories',
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
