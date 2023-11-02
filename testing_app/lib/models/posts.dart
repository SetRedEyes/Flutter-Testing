import 'package:testing_app/services/posts_service.dart';
import 'package:flutter/material.dart';

class Post {
  late int id;
  late String title;

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] as String;
  }
  Post({required this.id, required this.title});
}

class PostsNotifier extends ChangeNotifier {
  final PostService _postService;
  PostsNotifier(this._postService);

  bool _isLoading = false;
  final List<Post> _posts = [];

  List<Post> get posts => _posts;

  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    final posts = await _postService.fetchPosts();
    _posts.addAll(posts);
    notifyListeners();

    _isLoading = false;
    notifyListeners();
  }
}
