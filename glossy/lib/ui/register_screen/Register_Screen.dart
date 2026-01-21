import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/component/Button.dart';
import 'package:glossy/component/Dropdownmenu.dart';
import 'package:glossy/component/Textformfield.dart';
import 'package:glossy/res/Color.dart';
import 'package:glossy/ui/home_screen/Home_Screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController username_controller = TextEditingController();
  final TextEditingController email_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  //選択された値を格納する変数
  String? selectedGender;
  String? selectedHairType;
  String? selectedRole;

  //エラーメッセージ引数
  String? genderError;
  String? hairtypeError;
  String? roleError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
           // 左上の緑の円
          Positioned( 
            top: -300.h,
            left: -200.w, 
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/glossy_logo.png',
                ),
                Text(
                  "新規登録",
                  style: GoogleFonts.poppins(
                    color: AppColors.customorange,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Username_Textformfield(
                  controller: username_controller, 
                  width: 300.w, 
                ),
                SizedBox(height: 15.h),
                Email_Textformfield(
                  controller: email_controller, 
                  width: 300.w,
                ),
                SizedBox(height: 15.h),
                Password_Textformfield(
                  controller: password_controller, 
                  width: 300.w
                ), 
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SizedBox(width: 50.w),
                    Dropdownmenu(
                      onChanged: (value){
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      labelText: '性別',
                      items: ['男性', '女性',],
                      hint: '性別',
                      width: 90.w, 
                      errorMessage: genderError,
                    ),
                    SizedBox(width: 50.w),
                    Dropdownmenu(
                      onChanged: (value){
                        setState(() {
                          selectedHairType = value;
                        });
                      },
                      labelText: '髪質',
                      items: ['直毛', 'くせ毛', 'その他','パーマ','縮毛矯正'],
                      hint: '髪質',
                      width: 90.w,
                      errorMessage: hairtypeError,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SizedBox(width: 50.w),
                    Dropdownmenu(
                      onChanged: (value){
                        setState(() {
                          selectedRole = value;
                        });
                      },
                      items: ['はい', 'いいえ'],
                      hint: "", 
                      width: 200.w, 
                      labelText: 'あなたは美容師ですか？',
                      errorMessage: roleError,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                RegisterButton(
                  onPressed:()async{
                    //メールアドレスとパスワードでユーザー登録 
                    setState(() {
                      genderError = (selectedGender == null) ? '性別を選択してください' : null;
                      hairtypeError = (selectedHairType == null) ? '髪質を選択してください' : null;
                      roleError = (selectedRole == null) ? '選択してください' : null;
                    });
                    // どれか未入力なら処理中止
                    if (selectedGender == null ||
                        selectedHairType == null ||
                        selectedRole == null){
                      return;
                    }
                    try{
                      //⭐︎Todo 新規登録処理
                      print('性別:$selectedGender');
                      print('髪質:$selectedHairType');
                      print('美容師ですか？:$selectedRole');
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.createUserWithEmailAndPassword(
                        email: email_controller.text, 
                        password: password_controller.text
                      );
                      await registerUser(
                        email: email_controller.text,
                        username: username_controller.text,
                        gender: selectedGender!,
                        hairType: selectedHairType!,
                        isHairdresser: selectedRole!,
                      );
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      //エラー処理
                      print("Auth エラー: ${e.message}");
                      
                      // メール重複時のメッセージ
                      if (e.code == 'email-already-in-use') {
                        // ここでダイアログなどでUI表示してあげても良い
                        print("このメールアドレスは既に使用されています。");
                      }
                    }
                  }
                ),    
              ]
            ),
          )
        ],
      )
    );
  }
}

Future<void> registerUser({
  required String email,
  required String username,
  required String gender,
  required String hairType,
  required String isHairdresser,
}) async {
  try {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
      "user_id": uid,
      "name": username,
      "email": email,
      "bio": "",
      "gender_cd": gender == "男性",
      "hair_type": hairType,
      "icon_url": "",
      "role": isHairdresser == "はい",
      "createdAt": FieldValue.serverTimestamp(),
    });

    print("登録成功！");
  } catch (e) {
    print("Firestore エラー: $e");
    rethrow;
  }
}   