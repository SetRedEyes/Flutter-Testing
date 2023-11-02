import 'package:flutter/material.dart';

/// The [Favorites] class holds a list of favorite items saved by the user.
class FavoritesNotifier extends ChangeNotifier {
  final List<int> _favoriteItems = [];

  List<int> get items => _favoriteItems;

  num get favoritesAmount => _favoriteItems.length;

  void clear() {
    _favoriteItems.clear();
    notifyListeners();
  }

  void add(int itemNo) {
    if (itemNo <= 0) {
      throw Exception('itemNo must be positive');
    }

    _favoriteItems.add(itemNo);
    notifyListeners();
  }

  void remove(int itemNo) {
    _favoriteItems.remove(itemNo);
    notifyListeners();
  }
}
