import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/ui/post_screen/Post_Screen.dart';
import 'package:glossy/ui/profile_screen/Profile_Screen.dart';
import 'package:glossy/ui/favorite_screen/favorite_screen.dart';
import 'package:glossy/ui/home_screen/Home_Screen.dart';
import 'package:glossy/ui/itemdetail_screen/itemdetail_screen.dart';
import 'package:glossy/ui/login_screen/Login_Screen.dart';
import 'package:glossy/ui/register_screen/Register_Screen.dart';
import 'package:glossy/ui/search_screen/serch_screen.dart';
import 'package:glossy/ui/shopping_screen/shopping_screen.dart';

import 'package:glossy/ui/splash_screen/Splash_Screen.dart';

import 'package:glossy/ui/search_history/search_history.dart'; // ← 追加

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const designSize =  Size(393, 852);
    return ScreenUtilInit(
      //元となる画面サイズ（iphone15)
      designSize:designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ ,child){
        return MaterialApp(
          initialRoute: '/splash',
          routes: {
            '/login': (context) => LoginScreen(),
            'register': (context) => RegisterScreen(),
            '/home': (context) => HomeScreen(),
            '/shopping': (context) => ShoppingScreen(),
            '/splash': (context) => SplashScreen(),
            '/post': (context) => PostScreen(),
            '/favorite': (context) => FavoriteScreen(),
            '/itemdetail': (context) => ItemDetailScreen(),
            '/profile': (context) =>  Profile_Screen(),
            '/search': (context) =>  SearchScreen(),
            '/search_history': (context) => SearchHistoryScreen(), // ★ 追加
          },
          debugShowCheckedModeBanner: false,
          theme:ThemeData(
            useMaterial3: true,
          ) ,
          home:  SplashScreen(),
          title: 'ログインしているかどうかで画面遷移を変える' ,
        );
      },
    );
  }
}
