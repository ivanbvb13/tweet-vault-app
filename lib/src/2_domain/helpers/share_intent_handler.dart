import 'package:flutter/foundation.dart';

class ShareIntentHandler {
  void Function(String url)? onTweetShared;

  void init() {
    debugPrint('ShareIntentHandler initialized (stub - needs app_links fix)');
  }

  void dispose() {
    debugPrint('ShareIntentHandler disposed');
  }
}
