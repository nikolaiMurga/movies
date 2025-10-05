import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/common/mixins/snack_bar_mixin.dart';
import 'package:movies/core/theme/theme_provider.dart';
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
  int _currentPage = 1;
  final _debounce = Debounce();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieProvider.notifier).fetchMovies(page: _currentPage);
    });
    _scrollController.addListener(fetchPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchPage() {
    if (_isSearching) return;
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final state = ref.read(movieProvider);
      if (!state.isLoading && state.value != null) {
        _currentPage++;
        ref.read(movieProvider.notifier).fetchMovies(page: _currentPage);
      }
    }
  }

  void _reloadList() {
    _currentPage = 1;
    ref.read(movieProvider.notifier).reset();
    ref.read(movieProvider.notifier).fetchMovies(page: _currentPage);
  }

  void _onSearchChanged(String query) {
    if (query.length < 3) return;
    _debounce.run(action: () {
      _searchFocusNode.unfocus();
      ref.read(movieProvider.notifier).fetchMoviesBySearch(query: query);
    });
  }

  void _toggleSearch() {
    setState(() => _isSearching = !_isSearching);
    if (_isSearching) {
      _searchFocusNode.requestFocus();
    } else {
      _searchFocusNode.unfocus();
      _searchController.clear();
      _currentPage = 1;
      ref.read(movieProvider.notifier).reset();
      ref.read(movieProvider.notifier).fetchMovies(page: _currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(movieProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? Padding(
                key: const ValueKey('search_field'),
                padding: const EdgeInsets.only(right: 8.0),
                child: TextFormField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: const InputDecoration(hintText: AppStrings.search, border: InputBorder.none),
                  onChanged: (value) => _onSearchChanged(value),
                ),
              )
            : const Text(key: ValueKey('title'), AppStrings.movies),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            onPressed: () {
              ref.read(themeProvider.notifier).setTheme(themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
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

class Debounce {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run({required VoidCallback action}) {
    if (timer != null) timer!.cancel();
    timer = Timer(const Duration(seconds: 1), action);
  }
}
