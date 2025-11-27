import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/res/Color.dart';
//ログインボタン
class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  //コンストラクタで受け取る
  const LoginButton({
    Key? key,
    required this.onPressed,      
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.r,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ]
      ),
      child: TextButton(
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
      ),
    );
  }
}
//Googleログインボタン
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
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: AppColors.customgray,
            width: 1,
          ),
        ),
      ),
    );
  }
}
//新規登録ボタン
class NewregistrationButton extends StatelessWidget {
  final VoidCallback onPressed;
  //コンストラクタで受け取る
  const NewregistrationButton({
    Key? key,
    required this.onPressed,      
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.r,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(250.w,50.h),
          backgroundColor: AppColors.customorange,
        ),
        child: Text(
          "新規登録",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
          ),
        ),
      ),
    );
  }
}
class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  //コンストラクタで受け取る
  const RegisterButton({
    Key? key,
    required this.onPressed,      
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.r,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(250.w,50.h),
          backgroundColor: AppColors.customorange,
        ),
        child: Text(
          "新規登録",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
          ),
        ),
      ),
    );
  }
}