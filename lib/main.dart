import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/loginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'it4billing_pos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
