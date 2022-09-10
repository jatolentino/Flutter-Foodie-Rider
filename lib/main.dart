import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riders App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplashScreen(), //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
