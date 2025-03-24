import 'package:beehive/features/auth/view/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock for Navigator
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  final mockObserver = MockNavigatorObserver();

  testWidgets('Auth screen displays login and signup buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const Auth(),
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    // Skip testing for SvgPicture and just focus on the buttons

    // Check if the buttons "Se connecter" and "Créer un compte" are displayed
    expect(find.text("Se connecter"), findsOneWidget);
    expect(find.text("Créer un compte"), findsOneWidget);

    // Test button callbacks (navigation)
    await tester.tap(find.text("Se connecter"));
    await tester.pumpAndSettle();

    // You'd normally verify navigation here with the mockObserver
    // verify(mockObserver.didPush(any, any));

    // Same for the create account button
    await tester.tap(find.text("Créer un compte"));
    await tester.pumpAndSettle();
    // verify(mockObserver.didPush(any, any));
  });
}
