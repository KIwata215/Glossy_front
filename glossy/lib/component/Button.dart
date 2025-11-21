import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/res/Color.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  //コンストラクタで受け取る
  const LoginButton({
    Key? key,
    required this.onPressed,      
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppColors.customgreen,
        minimumSize: Size(250.w,60.h), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Text(
        "ログイン",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
        ),
      ),
    );
  }
}