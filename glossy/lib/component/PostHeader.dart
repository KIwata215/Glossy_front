import 'package:flutter/material.dart';
import 'package:glossy/res/Color.dart';

class PostHeader extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final String titleText;
  final String rightText;
  final Color textColor;
  final VoidCallback? onRightTap;
  final Widget? child; // ← ★追加（検索バーなどを置ける）
  const PostHeader({
    super.key,
    this.backgroundColor = Colors.white,
    this.titleText = "新規投稿",
    this.rightText = "次へ",
    this.textColor = AppColors.custompurple,
    this.onRightTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: backgroundColor),
      child: SafeArea(
        child: child != null
            ? child! // ← ★検索バーなどをそのまま表示
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    titleText ?? "",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: onRightTap,
                    child: Text(
                      rightText ?? "",
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
