import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../component/PostHeader.dart';
import '../../component/AppBar.dart';
import '../../res/Color.dart';

class PostDetailScreen extends StatelessWidget {
  final List<AssetEntity> mediaList;
  final String description;
  final int difficulty;
  final List<String> tags;

  const PostDetailScreen({
    super.key,
    required this.mediaList,
    required this.description,
    required this.difficulty,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PostHeader(titleText: "投稿詳細", rightText: ""),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ① 画像スワイプ
            SizedBox(
              height: 420,
              child: PageView.builder(
                itemCount: mediaList.length,
                itemBuilder: (context, index) {
                  final media = mediaList[index];
                  return FutureBuilder(
                    future: media.thumbnailDataWithSize(
                      const ThumbnailSize(1000, 1000),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(color: Colors.black);
                      }
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ② ユーザー名（仮）
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "ECC_123QWE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            // ③ 概要
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(description),
            ),

            const SizedBox(height: 12),

            // ④ タグ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: tags
                    .map(
                      (tag) =>
                          Text(tag, style: const TextStyle(color: Colors.blue)),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // ⑤ 難易度
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: index < difficulty ? Colors.amber : Colors.grey[300],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ⑥ 使用したアイテム（仮）
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "使用したアイテム",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _itemBox("サロニア", "2500円"),
                  const SizedBox(width: 12),
                  _itemBox("ケープ", "1190円"),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _itemBox(String name, String price) {
    return Column(
      children: [
        Container(width: 60, height: 60, color: Colors.grey[300]),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 12)),
        Text(price, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
