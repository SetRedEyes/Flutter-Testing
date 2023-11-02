import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/favorites.dart';
import '../models/posts.dart';
import 'favorites.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = '/';

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PostsNotifier>().fetchPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing App'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              context.go('/${FavoritesPage.routeName}');
            },
            icon: const Icon(Icons.favorite_border),
            label: const Text('Favorites'),
          ),
        ],
      ),
      body: Consumer<PostsNotifier>(builder: (context, notifier, child) {
        if (notifier.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              key: Key('progress-indicator'),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          );
        }
        return ListView.builder(
          itemCount: notifier.posts.length,
          cacheExtent: 20.0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            final post = notifier.posts[index];
            return ItemTile(post);
          },
        );
      }),
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile(this.item, {super.key});

  final Post item;

  @override
  Widget build(BuildContext context) {
    var favoritesList = Provider.of<FavoritesNotifier>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[item.id % Colors.primaries.length],
        ),
        title: Text(
          'Item ${item.id}',
          key: Key('text_${item.id}'),
        ),
        subtitle: Text(item.title),
        trailing: IconButton(
          key: Key('icon_$item'),
          icon: favoritesList.items.contains(item.id)
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          onPressed: () {
            !favoritesList.items.contains(item.id)
                ? favoritesList.add(item.id)
                : favoritesList.remove(item.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(favoritesList.items.contains(item.id)
                    ? 'Added to favorites.'
                    : 'Removed from favorites.'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
