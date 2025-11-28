import 'package:flutter/material.dart';

class BottomAppBarCustom extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomAppBarCustom({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  static const double barHeight = 75;
  static const double iconSize = 28;
  static const double postIconSize = 55;  

  static const Color selectedIconColor = Color(0xFFE3D0E2);
  static const Color unselectedIconColor = Color(0xFFC0C0C0);
  static const Color selectedTextColor = Color(0xFFA674A4);
  static const Color unselectedTextColor = Color(0xFF1C331D);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: barHeight + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(icon: Icons.home, label: 'ホーム', index: 0),
          _buildItem(icon: Icons.search, label: '検索', index: 1),
          _buildPostItem(index: 2),  // ← 投稿
          _buildItem(icon: Icons.shopping_bag, label: 'ショッピング', index: 3),
          _buildItem(icon: Icons.person, label: 'プロフィール', index: 4),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: isSelected ? selectedIconColor : unselectedIconColor,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? selectedTextColor : unselectedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 投稿アイコンの色は「固定」
  Widget _buildPostItem({required int index}) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              size: postIconSize,
              color: selectedIconColor,   // ← ここは固定！
            ),
            const SizedBox(height: 2),
            Text(
              '投稿',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? selectedTextColor : unselectedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
