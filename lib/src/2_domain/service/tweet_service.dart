import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tweet_vault_app/src/2_domain/dto/tweet_dto.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_tweet_service.dart';

class TweetService implements ITweetService {
  final SupabaseClient _client;

  TweetService(this._client);

  @override
  Future<List<TweetDto>> getTweets() async {
    try {
      final response = await _client
          .from('tweets')
          .select()
          .order('saved_at', ascending: false);
      return (response as List)
          .map((e) => TweetDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener tweets: $e');
    }
  }

  @override
  Future<List<TweetDto>> getTweetsByCategory(String categoryId) async {
    try {
      final response = await _client
          .from('tweets')
          .select()
          .eq('category_id', categoryId)
          .order('saved_at', ascending: false);
      return (response as List)
          .map((e) => TweetDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener tweets por categoría: $e');
    }
  }

  @override
  Future<TweetDto> saveTweet({
    required String tweetId,
    required String url,
    String? text,
    String? author,
    String? handle,
    DateTime? publishedAt,
    String? categoryId,
    List<String>? images,
  }) async {
    try {
      final response = await _client
          .from('tweets')
          .upsert({
            'tweet_id': tweetId,
            'url': url,
            'text': text,
            'author': author,
            'handle': handle,
            'published_at': publishedAt?.toIso8601String(),
            'category_id': categoryId,
            'images': images,
          })
          .select()
          .single();
      return TweetDto.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al guardar tweet: $e');
    }
  }

  @override
  Future<TweetDto> updateTweetCategory(
      String tweetId, String categoryId) async {
    try {
      final response = await _client
          .from('tweets')
          .update({'category_id': categoryId})
          .eq('tweet_id', tweetId)
          .select()
          .single();
      return TweetDto.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al actualizar categoría del tweet: $e');
    }
  }

  @override
  Future<void> deleteTweet(String tweetId) async {
    try {
      await _client.from('tweets').delete().eq('tweet_id', tweetId);
    } catch (e) {
      throw Exception('Error al eliminar tweet: $e');
    }
  }

  @override
  Future<List<TweetDto>> searchTweets(String query) async {
    try {
      final response = await _client
          .from('tweets')
          .select()
          .or('text.ilike.%$query%,author.ilike.%$query%,handle.ilike.%$query%')
          .order('saved_at', ascending: false);
      return (response as List)
          .map((e) => TweetDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar tweets: $e');
    }
  }
}
