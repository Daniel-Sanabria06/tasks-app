import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/config/theme/app_theme.dart';
import 'package:flutter_tasks_app/src/pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

String apiUrl = '${dotenv.env['urlServer']}';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Tasks',
      theme: AppTheme().getTheme(),
      home: AnimatedSplashScreen(
        splash: "assets/animations/intro.gif",
        splashIconSize: 3000.0,
        centered: true,
        nextScreen: MyHomePage(),
        backgroundColor: Colors.grey.shade100,
        duration: 900,
      ),
    );
  }
}
