import 'package:flutter/material.dart';
import 'package:glossy/res/Color.dart';

class PostHeader extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final String titleText;
  final String rightText;
  final Color textColor;
  final VoidCallback? onRightTap;
  const PostHeader({
    super.key,
    this.backgroundColor = const Color(0xFF2B2B2B),
    this.titleText = "新規投稿",
    this.rightText = "次へ",
    this.textColor = AppColors.customgreen,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: backgroundColor),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// ←戻るボタン
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
            ),

            /// 中央タイトル
            Text(
              titleText,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// 右「次へ」ボタン
            GestureDetector(
              onTap: onRightTap,
              child: Text(
                rightText,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
