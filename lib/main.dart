import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social/constant/colors.dart';
import 'package:social/pages/create_account.dart';
import 'package:social/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor, elevation: 0, centerTitle: true),
        scaffoldBackgroundColor: primaryText,
        iconTheme: const IconThemeData().copyWith(color: primaryColor),
        textTheme: const TextTheme(
            headline1: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 40.0,
              color: secondaryText,
            ),
            headline2: TextStyle(
              color: secondaryText,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            headline3: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: secondaryText,
            ),
            headline4: TextStyle(
              fontSize: 14.0,
              color: secondaryText,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
            bodyText1: TextStyle(
              color: secondaryText,
              fontSize: 16.0,
              letterSpacing: 1.0,
            ),
            bodyText2: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: primaryColor,
              letterSpacing: 1.0,
            ),
            caption: TextStyle(color: Colors.white, letterSpacing: 1.2)),
      ),
      title: "Social",
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
