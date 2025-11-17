import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/res/Color.dart';

class Username_Textformfield extends StatefulWidget{
  final TextEditingController controller;
  final String labelText;
  final double width;
  final double height;

  Username_Textformfield({required this.controller, required this.labelText, required this.width, required this.height});

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
            widget.labelText,
            style: TextStyle(
              color: AppColors.customblack,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 2.h),
        ],
    );
  }
}

class Email_Textformfield extends StatefulWidget{
  final TextEditingController controller;
  final String labelText;
  final double width;

  Email_Textformfield({required this.controller, required this.labelText, required this.width,});

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
            widget.labelText,
            style: TextStyle(
              color: AppColors.customblack,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: widget.width,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: ValidateText.email,
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

class ValidateText {
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
