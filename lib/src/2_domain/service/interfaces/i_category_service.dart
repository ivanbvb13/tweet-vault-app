import 'package:tweet_vault_app/src/2_domain/dto/category_dto.dart';

abstract class ICategoryService {
  Future<List<CategoryDto>> getCategories();
  Future<CategoryDto> createCategory(String name, String color);
  Future<CategoryDto> updateCategory(String id, String name, String color);
  Future<void> deleteCategory(String id);
  Future<void> setDefaultCategory(String id);
}
