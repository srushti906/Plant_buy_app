// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:green_square/main.dart'; // Update to your actual app import path
// import 'package:green_square/homepage.dart'; // Ensure this import is correct

// void main() {
//   testWidgets('SignInPage has a Sign In button', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(GreenSquareApp());

//     // Verify that the SignInPage is displayed initially.
//     expect(find.text('Sign In'), findsOneWidget);

//     // Verify that the Sign In button is present.
//     expect(find.byType(ElevatedButton), findsOneWidget); // Adjust if needed
//   });

//   testWidgets('Navigation to HomePage after Sign In', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(GreenSquareApp());

//     // Verify initial screen is SignInPage.
//     expect(find.text('Sign In'), findsOneWidget);

//     // Simulate user input for sign in
//     await tester.enterText(find.byType(TextFormField).first, 'username');
//     await tester.enterText(find.byType(TextFormField).at(1), 'password');

//     // Tap the 'Sign In' button
//     await tester.tap(find.byType(ElevatedButton));
//     await tester.pumpAndSettle();  // Wait for the navigation to complete

//     // Verify that the HomePage is displayed
//     // Ensure 'Home Page Title or Content' matches actual content in HomePage
//     expect(find.text('Home Page Title or Content'), findsOneWidget);
//   });
// }
