import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieImage extends StatelessWidget {
  final String imageUrl;
  const MovieImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return               SizedBox(
      height: 290,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
          errorWidget: (context, url, error) {
            return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Icon(Icons.movie, size: 50)));
          },
        ),
      ),
    );
  }
}
