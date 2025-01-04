import 'package:firebase_iv/screens/dsahboardscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
  });

  testWidgets('Displays a list of movies', (WidgetTester tester) async {
    // Mock API response
    final mockResponse = json.encode([
      {'movie': 'Inception', 'rating': 8.8, 'image': '', 'imdb_url': ''},
      {'movie': 'Avatar', 'rating': 7.8, 'image': '', 'imdb_url': ''}
    ]);

    when(mockHttpClient.get(Uri.parse('https://dummyapi.online/api/movies')))
        .thenAnswer((_) async => http.Response(mockResponse, 200));

    // Build DashboardScreen
    await tester.pumpWidget(MaterialApp(home: DashboardScreen()));

    // Wait for data to load
    await tester.pumpAndSettle();

    // Check if movies are displayed
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('Avatar'), findsOneWidget);
  });

  testWidgets('Filters movies by rating', (WidgetTester tester) async {
    // Mock API response
    final mockResponse = json.encode([
      {'movie': 'Inception', 'rating': 8.8, 'image': '', 'imdb_url': ''},
      {'movie': 'Avatar', 'rating': 7.8, 'image': '', 'imdb_url': ''}
    ]);

    when(mockHttpClient.get(Uri.parse('https://dummyapi.online/api/movies')))
        .thenAnswer((_) async => http.Response(mockResponse, 200));

    // Build DashboardScreen
    await tester.pumpWidget(MaterialApp(home: DashboardScreen()));

    // Wait for data to load
    await tester.pumpAndSettle();

    // Check for movies before applying filter
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('Avatar'), findsOneWidget);

    // Slide rating filter to 8.0
    final slider = find.byType(Slider);
    await tester.drag(slider, const Offset(100, 0)); // Drag slider to 8.0
    await tester.pumpAndSettle();

    // Check for filtered movies
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('Avatar'), findsNothing);
  });

  testWidgets('Shows error when API call fails', (WidgetTester tester) async {
    // Mock API response with error
    when(mockHttpClient.get(Uri.parse('https://dummyapi.online/api/movies')))
        .thenAnswer((_) async => http.Response('Error', 500));

    // Build DashboardScreen
    await tester.pumpWidget(MaterialApp(home: DashboardScreen()));

    // Wait for API response
    await tester.pumpAndSettle();

    // Check for error message
    expect(find.text('Failed to load movies'), findsOneWidget);
  });
}
