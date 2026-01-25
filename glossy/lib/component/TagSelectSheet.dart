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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== ヘッダー =====
          _buildHeader(context),
          const Divider(height: 1),

          // ===== タグ一覧 =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
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
          ),
        ],
      ),
    );
  }

  // ✅ クラス内に置く
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 中央タイトル（常に真ん中）
          const Text(
            'タグ選択',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // 左右ボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'キャンセル',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  '完了',
                  style: TextStyle(
                    color: AppColors.custompurple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
