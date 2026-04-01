import 'package:flutter_test/flutter_test.dart';
import 'package:tweet_vault_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TweetVaultApp());
    expect(find.text('Tweet Vault'), findsOneWidget);
  });
}
