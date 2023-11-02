import 'package:flutter_test/flutter_test.dart';
import 'package:testing_app/models/favorites.dart';

void main() {
  late FavoritesNotifier favorites;

  setUp(() {
    favorites = FavoritesNotifier();
  });
  group('Test empty list', () {
    test('Empty at first', () {
      expect(favorites.items.isEmpty, true);
    });
  });

  group('Test clearFavorites', () {
    test('Adding one post to favorites and clearing all list', () {
      var id = 99;
      favorites.add(id);
      expect(favorites.items.contains(id), true);
      favorites.clear();
      expect(favorites.items.isEmpty, true);
    });
  });

  group('adding and deleting', () {
    test('A new item should be added', () {
      var id = 99;
      favorites.add(id);
      expect(favorites.items.contains(id), true);
      expect(favorites.items.length, 1);
    });

    test('An item should be removed', () {
      var id = 45;
      favorites.add(id);
      expect(favorites.items.contains(id), true);
      favorites.remove(id);
      expect(favorites.items.contains(id), false);
      expect(favorites.items.isEmpty, true);
    });
  });

  group('When added negative number', () {
    test('expect throw exception', () {
      expect(() => favorites.add(-1), throwsException);
    });
  });
}
