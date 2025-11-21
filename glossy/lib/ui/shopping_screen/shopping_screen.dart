import 'package:flutter/material.dart';
import 'package:glossy/component/SearchBar.dart' as custom;

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 検索バー（コンポーネント化）
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: custom.SearchBar(),
              ),
            ),

            // ...existing code...（ここに画面の残りの UI を追加してください）
          ],
        ),
      ),
    );
  }
}