import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strokeprediction/screens/welcome-screen.dart';

Future<void> handleTokenExpired(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');
  await prefs.remove('refreshToken');


  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => WelcomeScreen()),
        (route) => false,
  );
}
