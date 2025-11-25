import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/component/Button.dart';
import 'package:glossy/component/Textformfield.dart';
import 'package:glossy/res/Color.dart';

class LoginScreen extends StatefulWidget{
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final TextEditingController email_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          // 左上の緑の円
          Positioned(
            top: -100.h,
            left: -80.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                color: AppColors.customgreen,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 右上の薄紫の円
          Positioned(
            top: 50.h,
            right: -40.w,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                color: AppColors.custompurple,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 右下の緑の円
          Positioned(
            bottom: -60.h,
            right: -40.w,
            child: Container(
              width: 240.w,
              height: 240.w,
              decoration: BoxDecoration(
                color: AppColors.customgreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 左下の薄紫の円
          Positioned(
            bottom: -60.h,
            left: -40.w,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                color: AppColors.custompurple,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: 125.h),
                Image.asset(
                  'assets/images/glossy_logo.png',
                ),
                SizedBox(height: 10),
                //Email_Textformfieldの呼び出し
                Email_Textformfield(
                  controller: email_controller, 
                  labelText: "メールアドレス", 
                  width: 300.w, 
                ),
                SizedBox(height: 10.h),
                Password_Textformfield(
                  controller:password_controller, 
                  labelText: "パスワード", 
                  width: 300.w
                ),
                SizedBox(height: 5.h),
                //ログインボタンの呼び出し
                LoginButton(
                  onPressed: (){
                    //⭐︎Todo　ログイン処理
                  },
                ),
                SizedBox(height: 15.h),
                //OR
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1, 
                        color: Colors.grey,
                        indent: 80.w,
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or', 
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.grey
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                        endIndent: 80.w,
                      )
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                GoogleLoginButton(
                  //⭐︎Todo Googleログイン処理
                  onPressed: (){
                    
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  "新規登録はこちら",
                  style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.customgray,
                  ),
                ),
                SizedBox(height: 10.h),
                //新規登録ボタン
                NewregistrationButton(
                  onPressed: (){
                    //⭐︎Todo 新規登録画面への遷移処理　

                  },
                ),
              ],
            )
          ),
        ],
      ) 
    );
  }
}