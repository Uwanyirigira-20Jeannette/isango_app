import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_theme.dart';
import 'package:isango_app/screens/auth/sign_in_screen.dart';
import 'package:isango_app/screens/auth/sign_up_screen.dart';
import 'package:isango_app/screens/auth/verify_email_screen.dart';

Widget _buildApp() {
  return MaterialApp(
    theme: AppTheme.light(),
    initialRoute: AppRoutes.signUp,
    routes: {
      AppRoutes.login: (context) => const SignInScreen(),
      AppRoutes.signUp: (context) => const SignUpScreen(),
      AppRoutes.verifyEmail: (context) => const VerifyEmailScreen(),
      AppRoutes.home: (context) => const Scaffold(body: Text('Home')),
    },
  );
}

Future<void> _scrollAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
}

void main() {
  group('SignUpScreen —', () {
    testWidgets('shows required-field errors when form is empty', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await _scrollAndTap(tester, find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Display name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('shows error when password is shorter than 8 characters', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Jean Test');
      await tester.enterText(fields.at(1), 'jean_123456789@stud.ur.ac.rw');
      await tester.enterText(fields.at(2), 'short');
      await tester.enterText(fields.at(3), 'short');

      await _scrollAndTap(tester, find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('shows error when passwords do not match', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Jean Test');
      await tester.enterText(fields.at(1), 'jean_123456789@stud.ur.ac.rw');
      await tester.enterText(fields.at(2), 'password123');
      await tester.enterText(fields.at(3), 'differentpassword');

      await _scrollAndTap(tester, find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('shows loading indicator while account creation is in progress', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Jean Test');
      await tester.enterText(fields.at(1), 'jean_123456789@stud.ur.ac.rw');
      await tester.enterText(fields.at(2), 'password123');
      await tester.enterText(fields.at(3), 'password123');
      await tester.pumpAndSettle();

      final button = find.byType(FilledButton);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Drain first delay (2 s) + second success delay (1.8 s) then settle navigation.
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 1900));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping "Sign In" footer link navigates to SignInScreen', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final link = find.text('Sign In');
      await tester.ensureVisible(link);
      await tester.pumpAndSettle();
      await tester.tap(link);
      await tester.pumpAndSettle();

      expect(find.byType(SignInScreen), findsOneWidget);
    });
  });
}
