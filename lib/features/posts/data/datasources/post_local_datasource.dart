import 'dart:convert';

import 'package:clean_archticture_posts/core/error/exception.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post_model.dart';

abstract class PostLocalDatasource {
  Future<List<PostModel>> getCachePosts();

  Future<Unit> cachePosts(List<PostModel> list);
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final SharedPreferences sharedPreferences;

  PostLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cachePosts(List<PostModel> list) {
    List postModelsToJson =
        list.map<Map<String, dynamic>>((e) => e.toJson()).toList();
    sharedPreferences.setString('CASHED_POSTS', json.encode(postModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<PostModel>> getCachePosts() {
    final jsonString = sharedPreferences.getString('CASHED_POSTS');
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<PostModel> jsonToPostModels = decodeJsonData
          .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();
      return Future.value(jsonToPostModels);
    } else {
      throw EmptyCacheException();
    }
  }
}
