import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_theme.dart';
import 'package:isango_app/screens/auth/sign_in_screen.dart';
import 'package:isango_app/screens/auth/sign_up_screen.dart';

Widget _buildApp() {
  return MaterialApp(
    theme: AppTheme.light(),
    initialRoute: AppRoutes.login,
    routes: {
      AppRoutes.login: (context) => const SignInScreen(),
      AppRoutes.signUp: (context) => const SignUpScreen(),
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
  group('SignInScreen —', () {
    testWidgets('shows required-field error when email is empty', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await _scrollAndTap(tester, find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows inline error for invalid email format', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'not-a-valid-email');
      await tester.enterText(fields.at(1), 'password123');

      await _scrollAndTap(tester, find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('shows required-field error when password is empty', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'jean_123456789@stud.ur.ac.rw');

      await _scrollAndTap(tester, find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows loading indicator while sign-in is in progress', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'jean_123456789@stud.ur.ac.rw');
      await tester.enterText(fields.at(1), 'password123');
      await tester.pumpAndSettle();

      final button = find.byType(FilledButton);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('button is disabled while loading', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'jean_123456789@stud.ur.ac.rw');
      await tester.enterText(fields.at(1), 'password123');
      await tester.pumpAndSettle();

      final button = find.byType(FilledButton);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pump();
      await tester.pump();

      final filledButton = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(filledButton.onPressed, isNull);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping "Create an account" navigates to SignUpScreen', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final link = find.text('Create an account');
      await tester.ensureVisible(link);
      await tester.pumpAndSettle();
      await tester.tap(link);
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
    });
  });
}
