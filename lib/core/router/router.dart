import 'package:go_router/go_router.dart';
import 'package:movies/core/log_service/log_service.dart';
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
        final idString = state.pathParameters['id'];

        try {
          if (idString == null) {
            LogService.addLog('movie details redirect failed. idString = $idString');
            return const MoviePage();
          }
          final id = int.parse(idString);
          if (id <= 0) throw const FormatException('Invalid ID');
          return MovieDetailsScreen(movieId: id);
        } catch (e) {
          LogService.addLog('movie details redirect failed. idString = $idString');
          return const MoviePage(); // Fallback
        }
      },
    ),
  ],
);
