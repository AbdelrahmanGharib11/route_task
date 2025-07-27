import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class PhotoGridScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'https://picsum.photos/id/1011/400/600',
    'https://picsum.photos/id/1012/400/400',
    'https://picsum.photos/id/1013/400/500',
    'https://picsum.photos/id/1014/400/300',
    'https://picsum.photos/id/1015/400/450',
    'https://picsum.photos/id/1016/400/350',
    'https://picsum.photos/id/1018/400/600',
    'https://picsum.photos/id/1019/400/500',
    'https://picsum.photos/id/1020/400/400',
    'https://picsum.photos/id/1021/400/550',
  ];

  PhotoGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: MasonryGridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2, // 👈 Exactly 2 columns
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  direction: ShimmerDirection.ttb,
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(height: 200, color: Colors.white),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
