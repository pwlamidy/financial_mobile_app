import 'package:financial_mobile_app/firebase_options.dart';
import 'package:financial_mobile_app/main.dart' as app;
import 'package:financial_mobile_app/screens/instrument_details.dart';
import 'package:financial_mobile_app/screens/instrument_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);

  group('login test', () {
    testWidgets('input mobile number and OTP in login screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      FirebaseAuth.instance.signOut();

      // Verify the login screen
      expect(find.text('Login'), findsOneWidget);

      // Input the mobile number
      await tester.enterText(find.byType(TextFormField), '12345678');

      // Finds the submit mobile button
      final Finder submitMobileBtn = find.byType(ElevatedButton);

      // Emulate a tap on the submit mobile button
      await tester.tap(submitMobileBtn);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify transition to OTP screen
      expect(find.text('OTP'), findsOneWidget);

      // Input the OTP
      await tester.enterText(find.byType(TextField), '111111');

      // Finds the submit OTP button
      final Finder submitOtpBtn = find.byType(ElevatedButton);

      // Emulate a tap on the submit OTP button
      await tester.tap(submitOtpBtn);

      // Trigger a frame.
      await tester.pumpAndSettle();
    });
  });

  group('instrument details test', () {
    testWidgets('show instrument details screen', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: InstrumentDetails(
          ticker: "TSLA",
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('TSLA'), findsOneWidget);
    });
  });

  group('search test', () {
    testWidgets('show search screen, input keyword and show search result',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: InstrumentSearch(),
      ));

      expect(find.text('Search'), findsOneWidget);

      // Input the search text
      await tester.enterText(find.byType(TextField), 'TSLA');

      await tester.pumpAndSettle();

      expect(find.text('Tesla'), findsOneWidget);
    });
  });

  group('watchlist test', () {
    testWidgets('add stock to/remove stock from watch list', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: InstrumentDetails(
          ticker: "TSLA",
        ),
      ));

      final addToWishlistBtn = find.byKey(Key("addToWishlistButtonKey"));

      // Get "add to wishlist" button
      Icon icon =
          tester.firstWidget(find.byKey(Key("addToWishlistIconKey"))) as Icon;

      final expectedColor =
          icon.color == Colors.yellow ? Colors.grey : Colors.yellow;

      await tester.tap(addToWishlistBtn);

      await tester.pumpAndSettle();

      // Get updated "add to wishlist" button
      icon =
          tester.firstWidget(find.byKey(Key("addToWishlistIconKey"))) as Icon;

      expect(
        icon,
        isA<Icon>().having((t) => t.color, 'color', expectedColor),
      );
    });
  });
}
