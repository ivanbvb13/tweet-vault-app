class CategoryDto {
  final String id;
  final String userId;
  final String name;
  final String color;
  final bool isDefault;
  final DateTime createdAt;

  CategoryDto({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
    required this.isDefault,
    required this.createdAt,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: _asString(json['id']),
      userId: _asString(json['user_id']),
      name: _asString(json['name']),
      color: _asString(json['color']),
      isDefault: _asBool(json['is_default']),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) return value.toString();
    return value.toString();
  }

  static bool _asBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value == 'true' || value == '1';
    return false;
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'color': color,
        'is_default': isDefault,
        'created_at': createdAt.toIso8601String(),
      };
}
