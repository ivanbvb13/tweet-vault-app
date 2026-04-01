import 'package:flutter/material.dart';
import 'package:tweet_vault_app/locator.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/auth/auth_wrapper.dart';
import 'package:tweet_vault_app/src/1_presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const TweetVaultApp());
}

class TweetVaultApp extends StatelessWidget {
  const TweetVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweet Vault',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}
