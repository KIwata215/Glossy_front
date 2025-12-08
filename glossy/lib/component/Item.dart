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
            /// 商品画像（正方形）
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

            /// ==== ここにハートを移動（文字の1行目の右上） ====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// ブランド
                  Expanded(
                    child: Text(
                      brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFFE3D0E2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// 右上のハート
                  Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Color(0xFFE3D0E2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 3),

            /// 商品名
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C331D),
                ),
              ),
            ),

            const SizedBox(height: 3),

            /// 価格
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                "¥${price.toString()}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C331D),
                ),
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

/// GridView（横3列）
class ItemGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ItemGrid({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return ItemCard(
          imageUrl: item["imageUrl"],
          name: item["name"],
          brand: item["brand"],
          price: item["price"],
        );
      },
    );
  }
}
