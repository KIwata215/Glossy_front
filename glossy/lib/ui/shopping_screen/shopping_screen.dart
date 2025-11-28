import 'package:flutter/material.dart';
import 'package:glossy/component/SearchBar.dart' as custom;
import 'package:glossy/component/HairGoods.dart'; // ← 追加

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 検索バーとハートアイコンを横並びに配置
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 検索バーを中央寄せ
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: custom.SearchBar(),
                    ),
                  ),
                  // ハートアイコンと「お気に入り」文字
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // favorite_screen.dart へ遷移
                            Navigator.pushNamed(context, '/favorite');
                          },
                          child: Icon(
                            Icons.favorite_border, // 縁のみ
                            color: const Color(0xFFA674A4),
                            size: 30, // 小さめ
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'お気に入り',
                          style: TextStyle(
                            fontSize: 10, // 小さめ
                            color: Color(0xFFA674A4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ↓ここにHairGoodsSelectorを追加
            const HairGoodsSelector(),
            // ...existing code...（ここに画面の残りの UI を追加してください）
          ],
        ),
      ),
    );
  }
}