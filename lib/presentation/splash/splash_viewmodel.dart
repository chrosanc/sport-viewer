import 'package:flutter/material.dart';
import 'package:streamed_mobile/presentation/home/home_screen.dart';

class SplashViewmodel extends ChangeNotifier {
  initilaizeSplash(BuildContext context) {
    _initialize(context);
  }

  Future<void> _initialize(context) async {
    await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
  }
}