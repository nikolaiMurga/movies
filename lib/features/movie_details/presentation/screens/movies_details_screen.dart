import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/features/movie_details/presentation/providers/movie_details_provider.dart';
import 'package:movies/resources/app_strings.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetails = ref.watch(movieDetailsProvider(movieId));

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.movieDetails)),
      body: movieDetails.when(
        data: (details) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  height: 364,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      details.posterPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.movie, size: 50),
                    ),
                  ),
                ),
                Text(details.title, style: Theme.of(context).textTheme.headlineMedium),
                Text('Rating: ${details.voteAverage}'),
                Text('Release Date: ${details.releaseDate}'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(details.overview),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
