import 'package:dio/dio.dart';
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
  late final String? baseUrl;
  late final String? token;

  StoryRemoteDataSourceImpl({
    required this.dio, required this.preferencesHelper,
  }) {
    init();
  }

  init() async {
    baseUrl = 'https://story-api.dicoding.dev/v1';
    if (baseUrl == null) {
      throw Exception('API_BASE_URL is not defined in the environment file');
    } else {
      dio.options.baseUrl = baseUrl!;
    }

    token = await preferencesHelper.getToken().then((value) => value);
    if (token != null) {
      dio.options.headers['Authorization'] =
      'Bearer $token';
    }

    if (!dio.interceptors.any((i) => i is InterceptorsWrapper)) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.next(options);
          },
          onResponse: (response, handler) async {
            return handler.next(response);
            }),
      );
    }
  }

  @override
  Future<ApiMessageResponse> addStory(AddStoryRequest newStory) async {
    FormData newStoryData = FormData.fromMap(newStory.toJson());
    final response = await dio.post(
      '/stories',
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      data: newStoryData,
    );

    if (ApiMessageResponse
        .fromJson(response.data)
        .error) {
      throw Exception('Failed to add story');
    } else {
      return ApiMessageResponse.fromJson(response.data);
    }
  }

  @override
  Future<LoginResponse> authLogin(LoginRequest loginData) async {
    final response = await dio.post('/login', data: loginData.toJson());

    if (LoginResponse
        .fromJson(response.data)
        .error) {
      throw Exception('Failed to login');
    } else {
      LoginResult loginResult = LoginResult.fromJson(
        email: loginData.email,
        json: response.data['loginResult'],
      );
      await preferencesHelper.setSavedUser(loginResult.toEntity());
      dio.options.headers['Authorization'] = 'Bearer ${loginResult.token}';

      return LoginResponse.fromJson(response.data);
    }
  }

  @override
  Future<ApiMessageResponse> authRegister(RegisterRequest registerData) async {
    final response = await dio.post(
      '/register',
      data: registerData.toJson(),
    );

    if (ApiMessageResponse
        .fromJson(response.data)
        .error) {
      throw Exception('Failed to register');
    } else {
      return ApiMessageResponse.fromJson(response.data);
    }
  }

  @override
  Future<StoryDetailResponse> getDetailStory(String id) async {
    final response = await dio.get('/stories/$id');

    if (response.statusCode == 200) {
      return StoryDetailResponse.fromJson(response.data);
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

    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load stories');
    }
  }
}