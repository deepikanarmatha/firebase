

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dsahboardscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOTPRequested = false;
  String _verificationId = ""; // To store the verification ID from Firebase
  String countryCode = '+91';

  // Request OTP
  Future<void> _requestOTP() async {
    if (_phoneController.text.isNotEmpty && _phoneController.text.length == 10) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '$countryCode${_phoneController.text}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Automatically signs in on Android devices if OTP is detected
            await FirebaseAuth.instance.signInWithCredential(credential);
            Fluttertoast.showToast(msg: 'Login Successful');
            _navigateToDashboard();
          },
          verificationFailed: (FirebaseAuthException e) {
            Fluttertoast.showToast(msg: 'Verification Failed: ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId; // Store the verification ID
              _isOTPRequested = true; // Show the OTP input field
            });
            Fluttertoast.showToast(msg: 'OTP Sent');
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId; // Store the verification ID
          },
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: $e');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please enter a valid phone number');
    }
  }

  // Verify OTP
  Future<void> _verifyOTP() async {
    if (_otpController.text.isNotEmpty) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _otpController.text,
        );
        // Sign in with the credential
        await FirebaseAuth.instance.signInWithCredential(credential);
        Fluttertoast.showToast(msg: 'Login Successful');
        _navigateToDashboard();
      } catch (e) {
        Fluttertoast.showToast(msg: 'Invalid OTP: $e');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please enter the OTP');
    }
  }

  // Navigate to Dashboard
  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade100,
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _requestOTP,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: const Text(
                  "Send OTP",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              if (_isOTPRequested) ...[
                // OTP Input Field
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    hintText: 'Enter OTP',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: const Text(
                    "Verify OTP",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
