import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snappy/data/models/model/model_login_result.dart';
import 'package:snappy/data/models/request/request_add_story.dart';
import 'package:snappy/data/models/request/request_login.dart';
import 'package:snappy/data/models/request/request_stories.dart';
import 'package:snappy/data/models/response/response_api_message.dart';
import 'package:snappy/data/models/response/response_login.dart';
import 'package:snappy/data/models/response/response_stories.dart';
import 'package:snappy/data/models/response/response_story_detail.dart';

import '../../common/utils/preferences_helper.dart';
import '../models/request/request_register.dart';

abstract class StoryRemoteDataSource {
  Future<StoriesResponse> getStories(StoriesRequest? configRequest);

  Future<StoryDetailResponse> getDetailStory(String id);

  Future<ApiMessageResponse> addStory(AddStoryRequest newStory);

  Future<LoginResponse> authLogin(LoginRequest loginData);

  Future<ApiMessageResponse> authRegister(RegisterRequest registerData);
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
  Future<ApiMessageResponse> addStory(AddStoryRequest newStory) async {
    final response = await dio.post(
      '/stories',
      data: newStory.toJson(),
    );
    print(response);

    if (response.statusCode == 200) {
      return ApiMessageResponse.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to add story');
    }
  }

  @override
  Future<LoginResponse> authLogin(LoginRequest loginData) async {
    final response = await dio.post('/login', data: loginData.toJson());
    print(response);

    if (response.statusCode == 200) {
      LoginResult loginResult = LoginResult.fromJson(
          email: loginData.email, json: response.data);
      await preferencesHelper.setSavedUser(loginResult);

      return LoginResponse.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<ApiMessageResponse> authRegister(RegisterRequest registerData) async {
    final response = await dio.post(
      '/register',
      data: registerData.toJson(),
    );
    print(response);

    if (response.statusCode == 200) {
      return ApiMessageResponse.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to register');
    }
  }

  @override
  Future<StoryDetailResponse> getDetailStory(String id) async {
    final response = await dio.get('/stories/$id');
    print(response);

    if (response.statusCode == 200) {
      return StoryDetailResponse.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to load story');
    }
  }

  @override
  Future<StoriesResponse> getStories(StoriesRequest? configRequest) async {
    final response = await dio.get(
      '/stories',
      queryParameters: configRequest?.toJson(),
    );
    print(response);

    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to load stories');
    }
  }
}
