import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testing_app/models/posts.dart';

class PostService {
  Future<List<Post>> fetchPosts() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = jsonDecode(response.body);
    return body.map((e) => Post.fromJson(e)).toList();
  }
}
