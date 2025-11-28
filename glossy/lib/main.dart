import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/ui/login_screen/Login_Screen.dart';
import 'package:glossy/ui/post_screen/Post_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const designSize = Size(393, 852);
    return ScreenUtilInit(
      //元となる画面サイズ（iphone15)
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          home: PostScreen(),
          title: 'LoginPage',
        );
      },
    );
  }
}
