import 'package:flutter/material.dart';
import 'package:glossy/component/SearchBar.dart' as custom;
import 'package:glossy/component/HairGoods.dart';
import 'package:glossy/component/AppBar.dart';
import 'package:glossy/component/Item.dart';
import 'package:glossy/router/AppRouter.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  // ★ テスト用商品データ（後で API に置き換え）
  List<Map<String, dynamic>> get testItems => List.generate(12, (index) {
        return {
          "imageUrl": "https://placehold.jp/150x150.png",
          "name": "商品名サンプル $index",
          "brand": "ブランド名",
          "price": 1980 + index * 100,
        };
      });

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
                      child: custom.SearchBar(),
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
                          child: Icon(
                            Icons.favorite_border,
                            color: const Color(0xFFA674A4),
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

            // ---------- ヘアカテゴリ セレクター ----------
            const HairGoodsSelector(),

            // ---------- 商品一覧グリッド（3列） ----------
            Expanded(
              child: ItemGrid(
                items: testItems,
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
            // TODO: 遷移処理
          AppRouter.navigate(context, 3, index);
          },
        ),
      ),
    );
  }
}
