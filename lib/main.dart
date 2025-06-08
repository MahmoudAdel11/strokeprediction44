import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:strokeprediction/screens/chat-bot-screen.dart';
import 'package:strokeprediction/screens/splashScreen.dart';
import 'package:strokeprediction/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(MyApp());
}

class MyApp extends  StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}