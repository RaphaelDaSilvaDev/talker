import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talker/src/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:talker/src/services/notify.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Notify().initNotify();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme()
      ),
      home: const SplashPage(),
    );
  }
}