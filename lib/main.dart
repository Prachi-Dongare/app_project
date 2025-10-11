import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart'; // importing your dashboard page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // removes the red debug label
      title: 'E-Education App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DashboardPage(), // starting page of your app
    );
  }
}
