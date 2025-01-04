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
        apiKey: "AIzaSyBQ0lCVjyvoTKqRPcrHKp0PSBWmvi_wH9A", // Replace with your API key
        appId: "1:1069098534914:android:ed4176e9a7cd6200047f1b", // Replace with your App ID
        messagingSenderId: "1069098534914", // Replace with your Messaging Sender ID
        projectId: "fir-iv-d45ad", // Replace with your Project ID
        storageBucket: "fir-iv-d45ad.firebasestorage.app", // Optional: Replace with your Storage Bucket
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Optional: Initialize Firebase Auth Emulator
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

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
