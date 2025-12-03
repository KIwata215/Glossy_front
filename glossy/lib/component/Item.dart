import 'package:flutter/material.dart';

/// 商品カードUI
class ItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String brand;
  final int price;
  final VoidCallback? onTap;

  const ItemCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.brand,
    required this.price,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品画像（正方形）
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 商品の文字情報エリア
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ブランド
                  Text(
                    brand,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // 商品名
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // 価格
                  Text(
                    "¥${price.toString()}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔥 GridView（横3列）のコンポーネント
/// これを呼び出すだけで商品が3列で並ぶ
class ItemGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ItemGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // ← 横3列
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65, // 高さの比率
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return ItemCard(
          imageUrl: item["imageUrl"],
          name: item["name"],
          brand: item["brand"],
          price: item["price"],
          onTap: () {
            // TODO: 商品詳細ページへ遷移
          },
        );
      },
    );
  }
}
