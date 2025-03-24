import 'package:beehive/features/auth/view/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Auth screen displays login and signup buttons', (WidgetTester tester) async {
    // Build the Auth screen widget
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Auth(),
        ),
      ),
    );

    // Verify the "Se connecter" and "Créer un compte" buttons are displayed
    expect(find.text("Se connecter"), findsOneWidget);
    expect(find.text("Créer un compte"), findsOneWidget);

    // Simulate tapping the "Se connecter" button
    await tester.tap(find.text("Se connecter"));
    await tester.pumpAndSettle();

    // Simulate tapping the "Créer un compte" button
    await tester.tap(find.text("Créer un compte"));
    await tester.pumpAndSettle();
  });
}
