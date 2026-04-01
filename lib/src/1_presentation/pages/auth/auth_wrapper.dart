import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/auth/login_page.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/home/home_page.dart';
import 'package:tweet_vault_app/src/2_domain/helpers/share_intent_handler.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/save_tweet/save_tweet_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _shareIntentHandler = ShareIntentHandler();
  String? _sharedTweetUrl;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
    _shareIntentHandler.onTweetShared = _onTweetShared;
    _shareIntentHandler.init();
  }

  void _checkSession() {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _isLoggedIn = session != null;
    });
  }

  void _onTweetShared(String url) {
    setState(() {
      _sharedTweetUrl = url;
    });
  }

  @override
  void dispose() {
    _shareIntentHandler.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _navigateToHome() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginPage(onLoginSuccess: _navigateToHome);
    }

    return HomePageWithShareIntent(
      sharedTweetUrl: _sharedTweetUrl,
      onLogout: _navigateToLogin,
    );
  }
}

class HomePageWithShareIntent extends StatefulWidget {
  final String? sharedTweetUrl;
  final VoidCallback onLogout;

  const HomePageWithShareIntent({
    super.key,
    this.sharedTweetUrl,
    required this.onLogout,
  });

  @override
  State<HomePageWithShareIntent> createState() =>
      _HomePageWithShareIntentState();
}

class _HomePageWithShareIntentState extends State<HomePageWithShareIntent> {
  @override
  void didUpdateWidget(HomePageWithShareIntent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sharedTweetUrl != null &&
        widget.sharedTweetUrl != oldWidget.sharedTweetUrl) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSaveTweetSheet(context, widget.sharedTweetUrl!);
      });
    }
  }

  void _showSaveTweetSheet(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SaveTweetPage(tweetUrl: url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(onLogout: widget.onLogout);
  }
}
