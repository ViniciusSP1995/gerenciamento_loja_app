import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
  
  runApp(MyApp());

  
} 

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.pinkAccent
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}