import 'package:firebase_iv/screens/loginsccreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  testWidgets('Displays phone number input and OTP input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Check if phone number field exists
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);

    // Tap Send OTP and verify OTP field appears
    await tester.enterText(find.byType(TextField), '1234567890');
    await tester.tap(find.text("Send OTP"));
    await tester.pump();

    // Check if OTP input field appears
    expect(find.text('Enter OTP'), findsOneWidget);
  });

  testWidgets('Shows error for invalid phone number', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Leave phone number empty and click Send OTP
    await tester.tap(find.text("Send OTP"));
    await tester.pump();

    // Check for error message
    expect(find.text('Please enter a valid phone number'), findsOneWidget);
  });
}
