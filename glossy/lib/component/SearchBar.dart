import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SearchBar({
    Key? key,
    this.controller,
    this.onChanged,
    this.hintText = '検索',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE), // 色をさらに薄く
        borderRadius: BorderRadius.circular(22.5), // 丸みを最大に
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFF333333), // 入力文字を見やすい濃いグレーに
        ),
        cursorColor: const Color(0xFF333333),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          isCollapsed: true,
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF989898),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 24,
            color: Color(0xFF989898),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}