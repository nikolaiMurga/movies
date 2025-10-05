import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies/features/movies/domain/models/movie.dart';

class MovieGridItem extends ConsumerWidget {
  final Movie movie;

  const MovieGridItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isFavorite = ref.watch(favoritesProvider).contains(movie.id);

    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.movie, size: 50),
            ),
          ),
          Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
          Text('Rating: ${movie.voteAverage.toStringAsFixed(1)}', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
