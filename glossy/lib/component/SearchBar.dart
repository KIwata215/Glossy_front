import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  // 🔽 追加：Enter（検索確定）時に呼ばれる
  final ValueChanged<String>? onSubmitted;

  final String hintText;

  const SearchBar({
    Key? key,
    this.controller,
    this.onChanged,
    this.onSubmitted, // 🔽 追加
    this.hintText = '検索',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(22.5),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        onChanged: onChanged,

        // 🔽 追加：キーボードの「検索 / Enter」
        onSubmitted: onSubmitted,

        textInputAction: TextInputAction.search, // 🔽 iOSで「検索」表示
        style: const TextStyle(fontSize: 24, color: Color(0xFF333333)),
        cursorColor: const Color(0xFF333333),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          isCollapsed: true,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF989898)),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 24, color: Color(0xFF989898)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
