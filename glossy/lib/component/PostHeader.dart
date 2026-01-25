import 'package:flutter/material.dart';
import 'package:glossy/res/Color.dart';

class PostHeader extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final String titleText;
  final String rightText;
  final Color textColor;
  final VoidCallback? onRightTap;
  final VoidCallback? onLeftTap;
  final Color? leftIconColor;
  final Widget? child;

  const PostHeader({
    super.key,
    this.backgroundColor = Colors.white,
    this.titleText = "新規投稿",
    this.rightText = "次へ",
    this.textColor = AppColors.custompurple,
    this.onRightTap,
    this.onLeftTap,
    this.child,
    this.leftIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: backgroundColor),

      // ❌ SafeAreaを使わない
      child:
          child ??
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onLeftTap ?? () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: leftIconColor ?? textColor,
                    size: 20,
                  ),
                ),
              ),

              Text(
                titleText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              GestureDetector(
                onTap: onRightTap,
                child: Text(
                  rightText,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
