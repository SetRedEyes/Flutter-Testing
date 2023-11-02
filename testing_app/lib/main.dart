import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/posts.dart';
import 'package:testing_app/services/posts_service.dart';
import 'models/favorites.dart';
import 'screens/favorites.dart';
import 'screens/home.dart';

void main() {
  runApp(const TestingApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) {
        return const HomePage();
      },
      routes: [
        GoRoute(
          path: FavoritesPage.routeName,
          builder: (context, state) {
            return const FavoritesPage();
          },
        ),
      ],
    ),
  ],
);

class TestingApp extends StatelessWidget {
  const TestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritesNotifier>(
          create: (_) => FavoritesNotifier(),
        ),
        ChangeNotifierProvider<PostsNotifier>(
          create: (_) => PostsNotifier(PostService()),
        )
      ],
      child: MaterialApp.router(
        title: 'Testing App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
