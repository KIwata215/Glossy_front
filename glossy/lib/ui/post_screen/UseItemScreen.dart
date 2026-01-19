import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../component/SearchBar.dart' as Custom;
import '../../component/PostHeader.dart';
import '../../component/HairGoods.dart';

class UseItemScreen extends StatefulWidget {
  const UseItemScreen({super.key});

  @override
  State<UseItemScreen> createState() => _UseItemScreenState();
}

class _UseItemScreenState extends State<UseItemScreen> {
  // ===============================
  // 🔥 状態管理
  // ===============================
  int selectedCategory = 2; // 初期：スタイリング剤
  bool isLoading = true;

  String? selectedItem;
  String? selectedItemImage;

  // 🔽 検索バー用 controller（追加）
  final TextEditingController _searchController = TextEditingController();

  // 🔽 楽天APIで取得した商品リスト（追加）
  List<Map<String, dynamic>> items = [];

  // 🔽 iOS実機用：PCのIP（ShoppingScreenと同じ）
  static const String apiBaseUrl = "http://自分自身のPIアドレス:3000";

  // 🔽 カテゴリ → 検索キーワード
  final List<String> categoryKeywords = [
    'ヘアケア',
    'ヘアアイロン',
    'スタイリング剤',
    'ドライヤー',
    'ヘア 美容 その他',
  ];

  @override
  void initState() {
    super.initState();
    // 🔥 初期表示時に楽天APIを呼ぶ（追加）
    fetchRakutenItems(keyword: categoryKeywords[selectedCategory]);
  }

  // ===============================
  // 🔥 楽天API 商品取得処理（追加）
  // ===============================
  Future<void> fetchRakutenItems({required String keyword}) async {
    try {
      final uri = Uri.parse("$apiBaseUrl/rakuten/search?keyword=$keyword");

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        setState(() {
          items = List<Map<String, dynamic>>.from(
            decoded["items"].map(
              (item) => {
                "name": item["name"] ?? "商品名不明",
                "price": item["price"] ?? 0,
                "image": item["image"] ?? "",
              },
            ),
          );
          isLoading = false;
        });
      } else {
        isLoading = false;
      }
    } catch (e) {
      debugPrint("Rakuten API Error: $e");
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// ===============================
                /// 🔍 ヘッダー + 検索バー
                /// ===============================
                PostHeader(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Custom.SearchBar(
                      controller: _searchController, // ⭐ 追加
                      hintText: "検索",
                      // ⭐ Enter押下で楽天API検索（追加）
                      onSubmitted: (value) {
                        final keyword = value.trim();
                        if (keyword.isEmpty) return;

                        setState(() {
                          isLoading = true;
                        });

                        fetchRakutenItems(keyword: keyword);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                /// ===============================
                /// 🧴 カテゴリ選択
                /// ===============================
                HairGoodsSelector(
                  initialIndex: selectedCategory,
                  onSelected: (index) {
                    setState(() {
                      selectedCategory = index;
                      isLoading = true;
                    });

                    // ⭐ カテゴリ変更で楽天API検索（追加）
                    fetchRakutenItems(keyword: categoryKeywords[index]);
                  },
                ),

                const SizedBox(height: 8),

                /// ===============================
                /// 🛒 商品一覧（楽天API）
                /// ===============================
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: items.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.58,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder: (context, index) {
                            final item = items[index];
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
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          height: 90,
                                          width: double.infinity,
                                          child: Image.network(
                                            item["image"],
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) =>
                                                Container(
                                                  color: Colors.grey[300],
                                                ),
                                          ),
                                        ),
                                      ),

                                      /// ✅ 選択チェック
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
                                    item["name"],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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

            /// ===============================
            /// ✅ 決定ボタン
            /// ===============================
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
