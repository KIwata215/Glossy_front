import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('お気に入り一覧'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0, // 影を消す
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Color(0xFFD9D9D9), // 線の色
            height: 1.0,
          ),
        ),
      ),
      body: const Center(child: Text('お気に入り商品一覧ページ')),
    );
  }
}