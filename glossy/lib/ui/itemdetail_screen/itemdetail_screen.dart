import 'package:flutter/material.dart';
import 'package:glossy/component/AppBar.dart';
import 'package:glossy/component/SearchBar.dart' as custom;

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final item =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // 例：item['rating']がなければ5.0を仮で使う
    final double rating = item?['rating']?.toDouble() ?? 5.0;

    if (item == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('商品詳細'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(child: Text('商品情報がありません')),
        bottomNavigationBar: BottomAppBarCustom(
          selectedIndex: 3,
          onTap: (index) {},
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                item['name'] ?? '商品詳細',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C331D),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/favorite');
                  },
                  child: Icon(
                    Icons.favorite_border,
                    color: const Color(0xFFA674A4),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'お気に入り',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA674A4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item['imageUrl'] ?? '', // ← 商品画像をitemから取得
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC0C0C0),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ...List.generate(5, (index) {
                    final starValue = index + 1;
                    if (rating >= starValue) {
                      return const Icon(Icons.star, color: Color(0xFFDDB867), size: 20);
                    } else if (rating >= starValue - 0.5) {
                      return const Icon(Icons.star_half, color: Color(0xFFDDB867), size: 20);
                    } else {
                      return const Icon(Icons.star_border, color: Color(0xFFDDB867), size: 20);
                    }
                  }),
                  const Spacer(),
                  Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFE3D0E2),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                item['brand'] ?? 'ブランド名', // ← ブランド名もitemから取得
                style: const TextStyle(
                  color: Color(0xFFE3D0E2),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                item['name'] ?? '', // ← 商品名もitemから取得
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                '¥${item['price']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              /// ===== ショッピングボタン =====
              Center(
                child: Container(
                  width: 331,
                  height: 47,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _shopTextButton('Amazon'),
                      _divider(),
                      _shopTextButton('楽天'),
                      _divider(),
                      _shopTextButton('Y!ショッピング'),
                    ],
                  ),
                ),
              ),

              // 四角の枠の外に「使用スタイル」とグリッドを配置
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '使用スタイル',
                  style: TextStyle(
                    color: Color(0xFFA674A4),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 500, // 100px × 5行
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 94 / 100,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 94,
                      height: 100,
                      color: Colors.grey[300],
                      child: Image.network(
                        'https://placehold.jp/94x100.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBarCustom(
        selectedIndex: 3,
        onTap: (index) {},
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 47,
      color: Colors.black,
    );
  }

  Widget _shopTextButton(String text) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
