import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/res/Color.dart';
import 'package:google_fonts/google_fonts.dart';

class Dropdownmenu extends StatefulWidget {
  final List<String> items;
  final String labelText;
  final String hint;
  final double width;
  final Function(String?)? onChanged;
  final String? errorMessage;

  Dropdownmenu({
    required this.items,
    required this.hint,
    required this.width,
    required this.labelText,
    this.onChanged,
    this.errorMessage,
  });

  @override
  _DropdownmenuState createState() => _DropdownmenuState();
}

class _DropdownmenuState extends State<Dropdownmenu> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: GoogleFonts.poppins(
            color: AppColors.customblack,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: widget.width,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.errorMessage == null ? Colors.grey : Colors.red, // ★枠色を変更
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                widget.hint,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              isExpanded: true,
              items: widget.items.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedValue = value);
                if (widget.onChanged != null) widget.onChanged!(value);
              },
            ),
          ),
        ),
        // ★エラーメッセージ表示
        if (widget.errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: Text(
              widget.errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}