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
class Account_Button extends StatelessWidget {
  final VoidCallback onPressed;
  //コンストラクタで受け取る
  const Account_Button({
    Key? key,
    required this.onPressed,      
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton (
      iconSize: 38.h,
      padding: EdgeInsets.zero, // 余白を減らす
      icon: const Icon(Icons.account_circle, color: AppColors.custompurple,),
      onPressed: onPressed,
    );
  }
}

class LikeButton extends StatefulWidget {
  final VoidCallback onPressed;
  LikeButton({Key? key, required this.onPressed}) : super(key: key);
  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked
            ? Icons.thumb_up_alt      // 👍 押した後
            : Icons.thumb_up_off_alt, // 👍 押す前
        color: isLiked ? AppColors.custompurple : AppColors.custompurple,
        size: 38.h,
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        widget.onPressed();
      },
    );
  }
}

class Comment_Button extends StatefulWidget{
  final VoidCallback onPressed;
  const Comment_Button({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<Comment_Button> createState() => _Comment_ButtonState();
}
class _Comment_ButtonState extends State<Comment_Button>{

  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: Icon(
        Icons.insert_comment, 
        color: AppColors.custompurple,
        size: 38.h,
      ),
      onPressed: widget.onPressed,
    );
  }
}

class Save_Button extends StatefulWidget{
  final VoidCallback onPressed;
  const Save_Button({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<Save_Button> createState() => _Save_ButtonState();
}
class _Save_ButtonState extends State<Save_Button>{

  bool isLiked = false;
  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: Icon(
        isLiked
            ? Icons.bookmark     //押した後
            : Icons.bookmark_border, //押す前
        color: isLiked ? AppColors.custompurple : AppColors.custompurple,
        size: 38.h,
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        widget.onPressed();
      },
    );
  }
}

class Share_Button extends StatefulWidget{
  final VoidCallback onPressed;
  const Share_Button({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<Share_Button> createState() => _Share_ButtonState();
}
class _Share_ButtonState extends State<Share_Button>{
  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: Icon(
        Icons.share, 
        color: AppColors.custompurple,
        size: 38.h,
        ),
      onPressed: (){
        widget.onPressed();
        //シェアボタンの処理
      },
    );
  }
}