import 'package:mocktail/mocktail.dart';
import 'package:testing_app/models/posts.dart';
import 'package:testing_app/services/posts_service.dart';
import 'package:test/test.dart';

class MockPostService extends Mock implements PostService {}

void main() {
  late PostsNotifier sut;
  late MockPostService mockPostService;

  final testPost = Post(id: 233, title: 'Test 1 content');
  setUp(() {
    mockPostService = MockPostService();
    sut = PostsNotifier(mockPostService);
  });

  test("initial values are correct", () {
    expect(sut.posts, []);
    expect(sut.isLoading, false);
  });

  test('should be subclass of Post entity', () {
    expect(testPost, isA<Post>());
  });
  group('getPosts', () {
    final posts = [
      Post(id: 233, title: 'Test 1 content'),
      Post(id: 734, title: 'Test 2 content'),
      Post(id: 434, title: 'Test 3 content'),
    ];

    void arrangePostServiceReturns3Posts() {
      when(() => mockPostService.fetchPosts()).thenAnswer((_) async => posts);
    }

    test('gets posts using th PostService', () async {
      arrangePostServiceReturns3Posts();
      verify(() => mockPostService.fetchPosts()).called(1);
    });

    test(
      """indicates loading of data,
    sets posts to the ones from the service,
    indicates that loading is done""",
      () async {
        arrangePostServiceReturns3Posts();
        final future = sut.fetchPosts();
        expect(sut.isLoading, true);
        await future;
        expect(sut.posts, posts);
        expect(sut.isLoading, false);
      },
    );
  });
}
