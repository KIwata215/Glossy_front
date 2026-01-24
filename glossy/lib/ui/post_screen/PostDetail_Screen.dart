import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../component/PostHeader.dart';
import '../../res/Color.dart';
import '../home_screen/Home_Screen.dart';
import 'dart:io';
import '../../component/AppBar.dart';

class PostDetailScreen extends StatelessWidget {
  final List<AssetEntity> mediaList;
  final String description;
  final int difficulty;
  final List<String> tags;
  final String? itemName;
  final String? itemImage;
  final List<Map<String, String>>? usedItems;

  const PostDetailScreen({
    super.key,
    required this.mediaList,
    required this.description,
    required this.difficulty,
    required this.tags,
    this.itemName,
    this.itemImage,
    this.usedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ❌ appBar は使わない
      /// appBar: PostHeader(...),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            /// -----------------------
            /// 上ヘッダー（完全に正常表示）
            /// -----------------------
            PostHeader(
              titleText: "投稿詳細",
              rightText: "",
              textColor: AppColors.customblack,
              onLeftTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
            ),

            /// -----------------------
            /// メインコンテンツ
            /// -----------------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ① 画像
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

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "ECC_123QWE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(description),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        children: tags
                            .map(
                              (tag) => Text(
                                tag,
                                style: const TextStyle(color: Colors.blue),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < difficulty
                                ? Colors.amber
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

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
                      child: (usedItems != null && usedItems!.isNotEmpty)
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: usedItems!.map((it) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: _itemBox(
                                      it['name'] ?? '',
                                      "",
                                      imagePath: it['image'],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : Row(
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
            ),
          ],
        ),
      ),

      /// -----------------------
      /// 下タブ
      /// -----------------------
      bottomNavigationBar: BottomAppBarCustom(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _itemBox(String name, String price, {String? imagePath}) {
    Widget thumb;

    if (imagePath != null && imagePath.isNotEmpty) {
      thumb = imagePath.startsWith('assets/')
          ? Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover)
          : Image.file(
              File(imagePath),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            );
    } else {
      thumb = Container(width: 60, height: 60, color: Colors.grey[300]);
    }

    return Column(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(6), child: thumb),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 12)),
        Text(price, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
