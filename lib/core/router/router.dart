import 'package:go_router/go_router.dart';
import 'package:movies/features/movies/presentation/screens/movies_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MovieScreen(),
    ),
  ],
);
