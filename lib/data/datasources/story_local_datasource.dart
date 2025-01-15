import 'package:snappy/data/models/model/model_story.dart';

import 'local/database_helper.dart';

abstract class MovieLocalDataSource {
  Future<String> insertListStory(List<StoryModel> listStory);

  Future<String> insertStory(StoryModel story);

  Future<StoryModel?> getStoryById(String id);

  Future<List<StoryModel>> getStories();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelper databaseHelper;

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertListStory(List<StoryModel> listStory) async {
    try {
      await databaseHelper.insertListStory(listStory);
      return 'Added to Story';
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> insertStory(StoryModel story) async {
    try {
      await databaseHelper.insertStory(story);
      return 'Added to Story';
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<StoryModel?> getStoryById(String id) async {
    final result = await databaseHelper.getStoryById(id);
    if (result != null) {
      return StoryModel.fromJson(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<StoryModel>> getStories() async {
    final result = await databaseHelper.getStories();
    return result.map((data) => StoryModel.fromJson(data)).toList();
  }
}
