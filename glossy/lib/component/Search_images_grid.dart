import 'package:flutter/material.dart';

class SearchImagesGrid extends StatelessWidget {
  final List<String> imageUrls;
  final void Function(int)? onImageTap;

  const SearchImagesGrid({super.key, required this.imageUrls, this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // 外部ScrollView使う場合
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 横3
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1, // 正方形
      ),
      itemCount: imageUrls.length > 30 ? 30 : imageUrls.length, // 最大30枚
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (onImageTap != null) {
              onImageTap!(index); // タップ時にコールバック呼び出し
            }
          },
          child: Container(
            color: Colors.grey[200],
            child: Image.asset(imageUrls[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
