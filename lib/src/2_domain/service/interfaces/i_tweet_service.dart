import 'package:tweet_vault_app/src/2_domain/dto/tweet_dto.dart';

abstract class ITweetService {
  Future<List<TweetDto>> getTweets();
  Future<List<TweetDto>> getTweetsByCategory(String categoryId);
  Future<TweetDto> saveTweet({
    required String tweetId,
    required String url,
    String? text,
    String? author,
    String? handle,
    DateTime? publishedAt,
    String? categoryId,
    List<String>? images,
  });
  Future<TweetDto> updateTweetCategory(String tweetId, String categoryId);
  Future<void> deleteTweet(String tweetId);
  Future<List<TweetDto>> searchTweets(String query);
}
