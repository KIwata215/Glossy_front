import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:glossy/component/SearchBar.dart' as custom;
import 'package:glossy/component/HairGoods.dart';
import 'package:glossy/component/AppBar.dart';
import 'package:glossy/component/Item.dart';
import 'package:glossy/router/AppRouter.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  int selectedCategoryIndex = 2; // 初期：スタイリング剤

  // 🔽 追加：検索バー用 controller
  final TextEditingController _searchController = TextEditingController();

  // 🔥 iOS 実機用：PC のローカル IP
  static const String apiBaseUrl = "http://自分のIPアドレスを入力:3000";

  // カテゴリ index → 楽天検索キーワード
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
    fetchRakutenItems(keyword: categoryKeywords[selectedCategoryIndex]);
  }

  // =====================================
  // 楽天 API 商品取得
  // =====================================
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
                "imageUrl": item["image"] ?? "https://placehold.jp/150x150.png",
                "name": item["name"] ?? "商品名不明",
                "brand": item["shop"] ?? "ブランド不明",
                "price": item["price"] ?? 0,
                "url": item["url"],
              },
            ),
          );
          isLoading = false;
        });
      } else {
        debugPrint("StatusCode: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Rakuten API Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- 検索バー + お気に入り ----------
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: custom.SearchBar(
                        controller: _searchController,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/favorite');
                          },
                          child: const Icon(
                            Icons.favorite_border,
                            color: Color(0xFFA674A4),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'お気に入り',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFA674A4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ---------- ヘアカテゴリ ----------
            HairGoodsSelector(
              initialIndex: selectedCategoryIndex,
              onSelected: (index) {
                setState(() {
                  selectedCategoryIndex = index;
                  isLoading = true;
                });

                fetchRakutenItems(keyword: categoryKeywords[index]);
              },
            ),

            // ---------- 商品一覧 ----------
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ItemGrid(
                      items: items,
                      onItemTap: (item) {
                        Navigator.pushNamed(
                          context,
                          '/itemdetail',
                          arguments: item,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBarCustom(
          selectedIndex: 3,
          onTap: (index) {
            AppRouter.navigate(context, 3, index);
          },
        ),
      ),
    );
  }
}
