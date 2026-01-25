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
  int selectedCategory = 2;
  bool isLoading = true;
  bool isPopping = false;

  Map<String, dynamic>? selectedItem;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> items = [];

  static const String apiBaseUrl = "http://192.168.0.7:3000";

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
    fetchRakutenItems(keyword: categoryKeywords[selectedCategory]);
  }

  Future<void> fetchRakutenItems({required String keyword}) async {
    setState(() => isLoading = true);

    final uri = Uri.parse("$apiBaseUrl/rakuten/search?keyword=$keyword");
    final response = await http.get(uri);

    if (!mounted) return;

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      setState(() {
        items = List<Map<String, dynamic>>.from(
          decoded["items"].map(
            (item) => {
              "name": item["name"] ?? "不明",
              "price": item["price"] ?? "0",
              "image": item["image"] ?? "",
            },
          ),
        );
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                /// ヘッダー + 検索バー
                PostHeader(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Custom.SearchBar(
                      controller: _searchController,
                      hintText: "検索",
                      onSubmitted: (value) {
                        final keyword = value.trim();
                        if (keyword.isEmpty) return;
                        fetchRakutenItems(keyword: keyword);
                      },
                    ),
                  ),
                ),

                /// カテゴリ選択
                HairGoodsSelector(
                  initialIndex: selectedCategory,
                  onSelected: (index) {
                    setState(() {
                      selectedCategory = index;
                    });
                    fetchRakutenItems(keyword: categoryKeywords[index]);
                  },
                ),

                /// アイテムグリッド
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
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
                            final isSelected =
                                selectedItem?["name"] == item["name"];

                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedItem = item);
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Image.network(
                                        item["image"],
                                        height: 90,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          height: 90,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      if (isSelected)
                                        const Positioned(
                                          right: 4,
                                          top: 4,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.purple,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item["name"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
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

            /// 決定ボタン
            // 決定ボタン
            if (selectedItem != null)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8D5EA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 80,
                      ),
                    ),
                    onPressed: () {
                      if (isPopping) return;
                      isPopping = true;

                      // ✅ Map<String, String に変換
                      final result = <String, String>{
                        "url": (selectedItem!["image"] ?? "").toString(),
                        "brand": (selectedItem!["name"] ?? "").toString(),
                        "money": (selectedItem!["price"] ?? "0").toString(),
                      };

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop<Map<String, String>>(context, result);
                      });
                    },
                    child: const Text(
                      "決定",
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
