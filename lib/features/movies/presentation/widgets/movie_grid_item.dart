import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies/common/widgets/movie_image.dart';
import 'package:movies/features/favorites/presentation/favorites_provider.dart';
import 'package:movies/features/movies/domain/models/movie.dart';

class MovieGridItem extends ConsumerWidget {
  final Movie movie;

  const MovieGridItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(movie.id);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              MovieImage(imageUrl: movie.posterPath),
              IconButton(
                onPressed: () => favoritesNotifier.toggleFavorite(movie.id),
                icon: Icon(
                  Icons.star_outlined,
                  color: isFavorite ? Colors.yellow : Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
          Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('Rating: ${movie.voteAverage.toStringAsFixed(1)}', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
