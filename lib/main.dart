import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/loginsccreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check the platform and initialize Firebase accordingly
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBLVBYH8fo4p1dHEh8vKQLAwR6yhOfdbVQ", // Replace with your API key
        appId: "1:336251933971:android:29200f86587e254fbeb6e6", // Replace with your App ID
        messagingSenderId: "336251933971", // Replace with your Messaging Sender ID
        projectId: "fir-otp-7b20c", // Replace with your Project ID
        storageBucket: "fir-otp-7b20c.firebasestorage.app", // Optional: Replace with your Storage Bucket
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Optional: Initialize Firebase Auth Emulator
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
