import 'package:flutter/material.dart';

class AppRouter {
  static void navigate(
    BuildContext context,
    int currentIndex,
    int nextIndex,
  ) {
    if (currentIndex == nextIndex) return;
    const routes = [
      '/home',
      '/search',
      '/post',
      '/shopping',
      '/profile',
    ];

    Navigator.pushReplacementNamed(
      context,
      routes[nextIndex],
    );
  }
}