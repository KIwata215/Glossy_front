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
        minimumSize: Size(250.w,50.h), 
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

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  //コンストラクタで受け取る
  const GoogleLoginButton({
    Key? key,
    required this.onPressed,      
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/images/google_icon.jpeg',
        height: 24.h,
        width: 24.w,
      ),
      onPressed: onPressed, 
      label: const Text(
        "Googleでログイン",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),  
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(250.w,50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),

        ),
      ),
    );
  }
}