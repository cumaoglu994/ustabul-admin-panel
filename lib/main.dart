import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ustabul_web_admin/views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'in platforma göre başlatılması
  if (kIsWeb || Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDumJOT__63av5SQRTzKGsDRF2YuyMQ-eY",
        appId: "1:462323504147:web:2aa3367a15938a70461be6",
        messagingSenderId: "462323504147",
        projectId: "ustabuul",
        storageBucket: "ustabuul.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp(); // iOS veya diğer platformlar için
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ustabul Web Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}
