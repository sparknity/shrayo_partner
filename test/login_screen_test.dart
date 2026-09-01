import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shreyo_partner/features/auth/presentation/screens/login_screen.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  testWidgets('LoginScreen renders Welcome header, phone input, and Continue button',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify Title and Subtitle
    expect(find.text('Welcome'), findsOneWidget);
    expect(
      find.text('Sign in to stay connected with your care workspace.'),
      findsOneWidget,
    );

    // Verify Mobile Number Field and Prefix
    expect(find.text('Mobile Number'), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);

    // Verify Continue Button
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Empty mobile number triggers validation error',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final continueButton = find.byKey(const Key('sign_in_button'));
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your mobile number'), findsOneWidget);
  });

  testWidgets('Valid mobile number advances to OTP verification screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final phoneField = find.byKey(const Key('employee_id_field'));
    await tester.enterText(phoneField, '9876543210');
    await tester.pumpAndSettle();

    final continueButton = find.byKey(const Key('sign_in_button'));
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // Verify OTP Step
    expect(find.text('Verification Code'), findsOneWidget);
    expect(find.byKey(const Key('otp_field_0')), findsOneWidget);
    expect(find.text('Verify & Continue'), findsOneWidget);
  });

  testWidgets('Tapping support link opens Operations Support bottom sheet',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final helpLink = find.byKey(const Key('help_link_button'));
    await tester.ensureVisible(helpLink);
    await tester.tap(helpLink);
    await tester.pumpAndSettle();

    expect(find.text('Operations Support'), findsOneWidget);
    expect(find.text('support@shrayohealth.com'), findsOneWidget);
    expect(find.text('Got It'), findsOneWidget);

    await tester.tap(find.text('Got It'));
    await tester.pumpAndSettle();
    expect(find.text('Operations Support'), findsNothing);
  });
}
