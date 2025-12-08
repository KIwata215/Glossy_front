import 'package:flutter/material.dart';
import '../res/Color.dart';

class TagSelect_Sheet extends StatelessWidget {
  final Function(String) onTagSelected;

  const TagSelect_Sheet({super.key, required this.onTagSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> tagList = [
      "ストレート",
      "癖毛",
      "パーマ",
      "ショート",
      "ミディアム",
      "ロング",
      "アップ",
      "学校",
      "仕事",
      "デート",
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "タグ選択",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.customgreen,
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tagList.map((tag) {
                return GestureDetector(
                  onTap: () {
                    onTagSelected(tag);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(tag),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
