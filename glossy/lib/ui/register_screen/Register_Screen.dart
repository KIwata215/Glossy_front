import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/component/Textformfield.dart';
import 'package:glossy/res/Color.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController username_controller = TextEditingController();
  final TextEditingController email_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
           // 左上の緑の円
          Positioned(
            top: -290.h,
            left: -140.w,
            child: Container(
              width: 400.w,
              height: 400.h,
              decoration: BoxDecoration(
                color: AppColors.customgreen,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 右上の薄紫の円
          Positioned(
            top: -50.h,
            right: -100.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                color: AppColors.custompurple,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 右下の緑の円
          Positioned(
            bottom: -250.h,
            right: -250.w,
            child: Container(
              width: 400.w,
              height: 400.w,
              decoration: BoxDecoration(
                color: AppColors.customgreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 左下の薄紫の円
          Positioned(
            bottom: -100.h,
            left: -100.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                color: AppColors.custompurple,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 左上戻るボタン追加
          Positioned(
            top: 50.h,
            left: 20.w,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 35.sp,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: 100.h),
                Image.asset(
                  'assets/images/glossy_logo.png',
                ),
                
                Text(
                  "新規登録",
                  style: GoogleFonts.poppins(
                    color: AppColors.customorange,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Username_Textformfield(
                  controller: username_controller, 
                  width: 300.w, 
                ),
                SizedBox(height: 20.h),
                Email_Textformfield(
                  controller: email_controller, 
                  width: 300.w,
                ),
                SizedBox(height: 20.h),
                Password_Textformfield(
                  controller: password_controller, 
                  width: 300.w
                ), 
              ]
            ),
          )
        ],
        
      )
    );
  }
}