import 'package:flutter/material.dart';

class SearchImagesGrid extends StatelessWidget {
  final List<String> imageUrls;

  const SearchImagesGrid({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 横3
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1, // 正方形
      ),
      itemCount: imageUrls.length > 30 ? 30 : imageUrls.length, // 最大30枚
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[200],
          child: Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}