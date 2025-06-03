import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(LaundryExpressApp());
}

class LaundryExpressApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Express',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
