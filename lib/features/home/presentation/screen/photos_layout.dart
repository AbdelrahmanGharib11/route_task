import 'package:flutter/material.dart';

class PhotosLayout extends StatelessWidget {
  PhotosLayout({super.key});
  final List<String> imageUrls = [
    'https://picsum.photos/400/600',
    'https://picsum.photos/400/400',
    'https://picsum.photos/400/550',
    'https://picsum.photos/400/300',
    'https://picsum.photos/400/450',
    'https://picsum.photos/400/500',
    'https://picsum.photos/400/350',
    'https://picsum.photos/400/600',
    'https://picsum.photos/400/400',
    'https://picsum.photos/400/500',
  ];

  @override
  Widget build(BuildContext context) {
    // Split list into two columns
    List<String> leftColumn = [];
    List<String> rightColumn = [];

    for (int i = 0; i < imageUrls.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(imageUrls[i]);
      } else {
        rightColumn.add(imageUrls[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT COLUMN
        Expanded(
          child: Column(
            children: List.generate(
              leftColumn.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: roundedImage(leftColumn[index]),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // RIGHT COLUMN
        Expanded(
          child: Column(
            children: List.generate(
              rightColumn.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: roundedImage(rightColumn[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget roundedImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
