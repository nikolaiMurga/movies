import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/features/movies/presentation/providers/movie_provider.dart';
import 'package:movies/features/movies/presentation/widgets/movie_grid_item.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({super.key});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  final ScrollController _scrollController = ScrollController();
  final String _query = 'star wars';
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieProvider.notifier).fetchMovies(_query, page: _currentPage);
    });

    _scrollController.addListener(fetchPage);
  }

  void fetchPage() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final state = ref.read(movieProvider);
      if (state.value != null && !state.value!.isLoading && state.value!.hasMore) {
        _currentPage++;
        ref.read(movieProvider.notifier).fetchMovies(_query, page: _currentPage);
      }
    }
  }

  void _reloadList() {
    _currentPage = 1;
    ref.read(movieProvider.notifier).reset();
    ref.read(movieProvider.notifier).fetchMovies(_query, page: _currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(movieProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: movieState.when(
        data: (state) {
          if (state.isLoading && state.movies == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!, style: const TextStyle(color: Colors.red)));
          }
          if (state.movies == null || state.movies!.isEmpty) {
            return const Center(child: Text('No movies found'));
          }
          return RefreshIndicator(
            onRefresh: () async => _reloadList(),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.58,
              ),
              itemCount: state.movies!.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.movies!.length && state.hasMore) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movie = state.movies![index];
                return MovieGridItem(movie: movie);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}
