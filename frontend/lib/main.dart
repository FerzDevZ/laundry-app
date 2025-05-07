// ✅ main.dart — Setup navigasi utama ke semua halaman
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'pages/login_page.dart';
import 'main_scaffold.dart'; // Import ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Esemka Laundry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
      ),
      home: const LoginPage(),
      builder: EasyLoading.init(),
      routes: {
        '/main': (context) => const MainScaffold(), // Tambahkan ini
      },
    );
  }
}