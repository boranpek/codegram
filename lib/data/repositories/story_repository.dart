import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories();
}

class SampleStoryRepository implements StoryRepository {
  final url = "https://codegram-6e8af-default-rtdb.firebaseio.com/story.json";

  @override
  Future<List<Story>> getStories() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = jsonDecode(response.body);
      // jsonBody.
      if (jsonBody is List) {
        return jsonBody.map((e) => Story.fromJson(e)).toList();
      }
    }
    throw NetworkError(response.statusCode.toString(), response.body);
  }
}

class NetworkError implements Exception {
  final String statusCode;
  final String message;
  NetworkError(this.statusCode, this.message);
}
