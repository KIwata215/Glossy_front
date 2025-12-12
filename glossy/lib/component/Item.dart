import 'package:flutter/material.dart';

/// 商品カードUI（ハートの状態を持つので StatefulWidget に変更）
class ItemCard extends StatefulWidget {
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
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isFavorite = false; // ← ハート状態（初期はオフ）

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// 上段（ブランド名 ＋ ハート）
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// ブランド名
                  Expanded(
                    child: Text(
                      widget.brand,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFFE3D0E2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// ハートアイコン（押すと色が変わる）
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: const Color(0xFFE3D0E2), // ON も OFF もこの色
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 3),

            /// 商品名
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                widget.name,
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
                "¥${widget.price.toString()}",
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
