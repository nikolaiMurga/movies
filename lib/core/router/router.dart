import 'package:go_router/go_router.dart';
import 'package:movies/features/movie_details/presentation/screens/movies_details_screen.dart';
import 'package:movies/features/movies/presentation/screens/movies_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MoviePage(),
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return MovieDetailsScreen(movieId: id);
      },
    ),
  ],
);