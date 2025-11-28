import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/res/Color.dart';
import 'package:google_fonts/google_fonts.dart';

class Username_Textformfield extends StatefulWidget{
  final TextEditingController controller;
  final double width;

  Username_Textformfield({required this.controller, required this.width,});

  @override
  _Username_Textformfield createState() => _Username_Textformfield();
}
class _Username_Textformfield extends State<Username_Textformfield>{
  String? username;

  void setUsername (String username) {
    this.username = username;
  }
  @override
  Widget build(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ユーザーネーム",
            style: TextStyle(
              color: AppColors.customblack,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: widget.width,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.disabled,
              validator: ValidateText.username,
              controller: widget.controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          )
        ],
    );
  }
}

class Email_Textformfield extends StatefulWidget{
  final TextEditingController controller;
  final double width;
  final Function(String)? onChanged;

  Email_Textformfield({required this.controller, required this.width, this.onChanged,});

  @override
  _Email_Textformfield createState() => _Email_Textformfield();
}
class _Email_Textformfield extends State<Email_Textformfield>{

  String? email;

  void setEmail (String email) {
    this.email = email;
  }
  @override
  Widget build(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "メールアドレス",
            style: GoogleFonts.poppins(
              color: AppColors.customblack,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: widget.width,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.disabled,
              validator: ValidateText.email,
              controller: widget.controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          )
        ],
    );
  }
}

class Password_Textformfield extends StatefulWidget{
  final TextEditingController controller;
  final double width;
  final bool? showForgotPassword;
  final Function(String)? onChanged;

  Password_Textformfield({required this.controller,required this.width, this.showForgotPassword, this.onChanged,});

  @override
  _Password_Textformfield createState() => _Password_Textformfield();
}
class _Password_Textformfield extends State<Password_Textformfield>{
  String? password; 
  void setPassword (String password) {
    this.password = password;
  }
  @override
  Widget build(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "パスワード",
            style: GoogleFonts.poppins(
              color: AppColors.customblack,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold
            ),
            
          ),
          SizedBox(height: 2.h),
          Container(
            width: widget.width,
            child: Column(
              children: [
                TextFormField(
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: ValidateText.password,
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                //パスワードを忘れた場合
                if(widget.showForgotPassword == true)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        //Todoパスワードリセット画面へ遷移
                      },
                      child: Text(
                        'パスワードを忘れた場合',
                        style: GoogleFonts.poppins(
                          color: AppColors.customblue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),     
              ],
            ),
          ),
        ],
    );
  }
}


class ValidateText {

static String? username(String? value){
    if(value != null){
      String pattern = r'^[a-zA-Z0-9_]{3,}$';
      RegExp regExp = RegExp(pattern);
      if(!regExp.hasMatch(value)){
        return '3文字以上の英数字入力してください';
      }
    }
  }

  static String? password(String? value){
    if(value != null){
      String pattern = r'^[a-zA-Z0-9]{6,}$';
      RegExp regExp = RegExp(pattern);
      if(!regExp.hasMatch(value)){
        return '6文字以上の英数字を入力してください';
      }
    }
  }

  static String? email(String? value){
    if(value != null){
      String pattern = r'^[0-9a-z_./?-]+@([0-9a-z-]+\.)+[0-9a-z-]+$';
      RegExp regExp = RegExp(pattern);
      if(!regExp.hasMatch(value)){
        return '正しいメールアドレスを入力してください';
      }
    }
  }
}
