import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/favorites.dart';
import 'package:testing_app/models/posts.dart';
import 'package:testing_app/screens/favorites.dart';
import 'package:testing_app/screens/home.dart';
import 'package:testing_app/services/posts_service.dart';

class MockPostService extends Mock implements PostService {}

void main() {
  late MockPostService mockPostService;

  setUp(() {
    mockPostService = MockPostService();
  });

  final posts = [
    Post(id: 233, title: 'Test 1 content'),
    Post(id: 734, title: 'Test 2 content'),
    Post(id: 434, title: 'Test 3 content'),
  ];

  void arrangePostServiceReturns3Posts() {
    when(() => mockPostService.fetchPosts()).thenAnswer((_) async => posts);
  }

  void arrangePostServiceReturns3PostsAfter2SecondWait() {
    when(() => mockPostService.fetchPosts()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return posts;
    });
  }

  Widget createWidgetUnderTest() {
    final router = GoRouter(
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritesNotifier>(
          create: (_) => FavoritesNotifier(),
        ),
        ChangeNotifierProvider<PostsNotifier>(
          create: (_) => PostsNotifier(mockPostService),
        )
      ],
      child: MaterialApp.router(
        title: 'Testing App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }

  group('Home Page Widget Tests', () {
    testWidgets(
      "loading indicator is displayed while waiting for posts",
      (tester) async {
        arrangePostServiceReturns3PostsAfter2SecondWait();
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byKey(const Key('progress-indicator')), findsOneWidget);

        await tester.pumpAndSettle();
      },
    );

    testWidgets('Testing if ListView shows up', (tester) async {
      arrangePostServiceReturns3Posts();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Testing Scrolling', (tester) async {
      arrangePostServiceReturns3Posts();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester
          .pump(const Duration(milliseconds: 500)); //forces widget rebuild

      expect(find.text('Item 233'), findsOneWidget);

      await tester.fling(
        find.byType(ListView),
        const Offset(0, -200),
        3000,
      );
      expect(find.text('Item 233'), findsNothing);
    });
  });

  testWidgets(
    "posts are displayed",
    (WidgetTester tester) async {
      arrangePostServiceReturns3Posts();

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      for (final post in posts) {
        expect(find.text('Item ${post.id}'), findsOneWidget);
        expect(find.text(post.title), findsOneWidget);
      }
    },
  );

  testWidgets('Testing IconButtons', (tester) async {
    arrangePostServiceReturns3Posts();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsNothing);
    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pumpAndSettle();
    expect(find.text('Added to favorites.'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsWidgets);
    await tester.tap(find.byIcon(Icons.favorite).first);
    await tester.pumpAndSettle();
    expect(find.text('Removed from favorites.'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });
}
