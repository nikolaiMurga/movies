import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/features/movies/presentation/providers/movie_provider.dart';
import 'package:movies/features/movies/presentation/screens/movies_screen.dart';

class MoviePage extends ConsumerWidget {
  const MoviePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieProvider.notifier).fetchMovies(page: 1);
    });
    return const MovieScreen();
  }
}
