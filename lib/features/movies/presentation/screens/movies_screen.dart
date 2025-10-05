import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/common/mixins/snack_bar_mixin.dart';
import 'package:movies/features/movies/presentation/providers/movie_provider.dart';
import 'package:movies/features/movies/presentation/widgets/empty_state_widget.dart';
import 'package:movies/features/movies/presentation/widgets/movie_grid_item.dart';
import 'package:movies/resources/app_strings.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({super.key});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> with SnackBarMixin {
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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final state = ref.read(movieProvider);
      if (!state.isLoading && state.value != null) {
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
      appBar: AppBar(title: const Text(AppStrings.movies)),
      body: movieState.when(
        data: (movies) {
          if (movies.isEmpty && !movieState.isLoading) {
            return RefreshIndicator(
              onRefresh: () async => _reloadList(),
              child: ListView(children: const [EmptyStateWidget()]),
            );
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
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieGridItem(movie: movie);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          WidgetsBinding.instance.addPostFrameCallback((_) => showSnackBar(context, err.toString()));
          return RefreshIndicator(
            onRefresh: () async => _reloadList(),
            child: ListView(children: const [EmptyStateWidget()]),
          );
        },
      ),
    );
  }
}
