import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tweet_vault_app/src/2_domain/dto/category_dto.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_category_service.dart';

class CategoryService implements ICategoryService {
  final SupabaseClient _client;

  CategoryService(this._client);

  @override
  Future<List<CategoryDto>> getCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }

  @override
  Future<CategoryDto> createCategory(String name, String color) async {
    try {
      final userId = _client.auth.currentUser?.id;
      final response = await _client
          .from('categories')
          .insert({
            'name': name,
            'color': color,
            'is_default': false,
            'user_id': userId,
          })
          .select()
          .single();
      return CategoryDto.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al crear categoría: $e');
    }
  }

  @override
  Future<CategoryDto> updateCategory(
      String id, String name, String color) async {
    try {
      final response = await _client
          .from('categories')
          .update({'name': name, 'color': color})
          .eq('id', id)
          .select()
          .single();
      return CategoryDto.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al actualizar categoría: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _client.from('categories').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar categoría: $e');
    }
  }

  @override
  Future<void> setDefaultCategory(String id) async {
    try {
      await _client.from('categories').update({'is_default': false});
      await _client
          .from('categories')
          .update({'is_default': true}).eq('id', id);
    } catch (e) {
      throw Exception('Error al establecer categoría por defecto: $e');
    }
  }
}
