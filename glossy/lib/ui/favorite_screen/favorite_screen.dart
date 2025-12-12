import 'package:flutter/material.dart';
import 'package:glossy/component/Item.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> favoriteItems = [
      {
        "imageUrl": "https://example.com/item1.jpg",
        "name": "ヘアオイル",
        "brand": "Brand A",
        "price": 1800,
      },
      {
        "imageUrl": "https://example.com/item2.jpg",
        "name": "ドライヤー",
        "brand": "Brand B",
        "price": 12000,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('お気に入り一覧'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // ← 必ず戻れる
          },
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFD9D9D9),
          ),
        ),
      ),

      body: ItemGrid(items: favoriteItems),
    );
  }
}
