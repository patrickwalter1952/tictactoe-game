
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe_game/screens/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const String title = "";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),

      debugShowCheckedModeBanner: false,

      home: HomePage(),
     );
  }

}

