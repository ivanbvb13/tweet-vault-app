import 'dart:convert';

class TweetDto {
  final String id;
  final String userId;
  final String tweetId;
  final String url;
  final String? text;
  final String? author;
  final String? handle;
  final DateTime? publishedAt;
  final DateTime savedAt;
  final String? categoryId;
  final List<String>? images;

  TweetDto({
    required this.id,
    required this.userId,
    required this.tweetId,
    required this.url,
    this.text,
    this.author,
    this.handle,
    this.publishedAt,
    required this.savedAt,
    this.categoryId,
    this.images,
  });

  factory TweetDto.fromJson(Map<String, dynamic> json) {
    return TweetDto(
      id: _asString(json['id']),
      userId: _asString(json['user_id']),
      tweetId: _asString(json['tweet_id']),
      url: _asString(json['url']),
      text: _asStringOrNull(json['text']),
      author: _asStringOrNull(json['author']),
      handle: _asStringOrNull(json['handle']),
      publishedAt: _parseDateTime(json['published_at']),
      savedAt: _parseDateTime(json['saved_at']) ?? DateTime.now(),
      categoryId: _extractCategoryId(json['category_id']),
      images: _parseImages(json['images']),
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) return value.toString();
    return value.toString();
  }

  static String? _asStringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) return value.toString();
    return value.toString();
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static String? _extractCategoryId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) return value['id']?.toString();
    return value.toString();
  }

  static List<String>? _parseImages(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      try {
        final parsed = jsonDecode(value);
        if (parsed is List) {
          return parsed.map((e) => e.toString()).toList();
        }
      } catch (_) {}
      return null;
    }

    if (value is List) {
      return value.map((e) {
        if (e is String) return e;
        if (e is Map) {
          if (e.containsKey('url')) return e['url'].toString();
          return e.toString();
        }
        return e.toString();
      }).toList();
    }

    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'tweet_id': tweetId,
        'url': url,
        'text': text,
        'author': author,
        'handle': handle,
        'published_at': publishedAt?.toIso8601String(),
        'saved_at': savedAt.toIso8601String(),
        'category_id': categoryId,
        'images': images,
      };
}
