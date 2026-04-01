class TweetUrlParser {
  static final RegExp _tweetUrlPattern = RegExp(
    r'https?://(?:x\.com|twitter\.com)/(\w+)/status/(\d+)',
  );

  static TweetUrlData? parse(String url) {
    final match = _tweetUrlPattern.firstMatch(url);
    if (match == null) return null;
    return TweetUrlData(
      username: match.group(1)!,
      tweetId: match.group(2)!,
      url: url,
    );
  }
}

class TweetUrlData {
  final String username;
  final String tweetId;
  final String url;

  TweetUrlData({
    required this.username,
    required this.tweetId,
    required this.url,
  });
}
