import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile_Screen extends StatefulWidget {
  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('プロフィール画面'),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                // Splash を通したいので root へ戻す
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: const Text('ログアウト（確認用）'),
            ),
          ],
        ),
      ),
    );
  }
}