import 'package:flutter/material.dart';
import '../../component/SearchBar.dart';
import '../../component/PostHeader.dart';
import '../../res/Color.dart';
import '../../component/SearchBar.dart' as Custom;
import '../../component/HairGoods.dart';

class UseItemScreen extends StatefulWidget {
  const UseItemScreen({super.key});

  @override
  State<UseItemScreen> createState() => _UseItemScreenState();
}

class _UseItemScreenState extends State<UseItemScreen> {
  int selectedCategory = 2; // 初期はスタイリング剤
  String searchKeyword = "";
  String? selectedItem; // アイテムを選んだかどうか
  String? selectedItemImage; //選択したアイテムの画像パス

  // ⭐ ダミーデータ（後で楽天APIに差し替え）
  List<Map<String, String>> dummyItems = [
    {
      "name": "プロダクトバーム",
      "price": "2180",
      "image": "assets/images/product_balm.png",
    },
    {
      "name": "メルティバターバーム",
      "price": "1800",
      "image": "assets/images/melt_butter_balm.png",
    },
    {
      "name": "N. ナチュラルバーム",
      "price": "1800",
      "image": "assets/images/natural_balm.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// ---------------------------
                /// ヘッダー（中に検索バーを入れる）
                /// ---------------------------
                PostHeader(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Custom.SearchBar(
                      hintText: "検索",
                      onChanged: (value) {
                        setState(() {
                          searchKeyword = value;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                /// ---------------------------
                /// カテゴリ選択
                /// ---------------------------
                HairGoodsSelector(
                  initialIndex: 2,
                  onSelected: (index) {
                    setState(() {
                      selectedCategory = index;
                    });
                  },
                ),

                const SizedBox(height: 8),

                /// ---------------------------
                /// アイテム一覧（楽天APIに差し替え予定）
                /// ---------------------------
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: dummyItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.58,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      final item = dummyItems[index];
                      final isSelected = selectedItem == item["name"];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItem = item["name"];
                            selectedItemImage = item["image"];
                          });
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                // assets の画像を表示（角丸を適用）
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 90,
                                    width: double.infinity,
                                    child: Image.asset(
                                      item["image"]!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) =>
                                          Container(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                                /// 右上チェック
                                if (isSelected)
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item["name"]!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "¥${item["price"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            /// ---------------------------
            /// 決定ボタン（アイテム選択時のみ表示）
            /// ---------------------------
            if (selectedItem != null)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, {
                        'name': selectedItem!,
                        'image': selectedItemImage ?? '',
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 80,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D5EA),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "決定",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C331D),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
