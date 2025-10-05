import 'package:flutter/material.dart';
import 'package:movies/resources/app_images.dart';
import 'package:movies/resources/app_strings.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(AppImages.noSearchResult, height: 148),
            ),
            const Text(AppStrings.moviesNotFound),
          ],
        ),
      ),
    );
  }
}
