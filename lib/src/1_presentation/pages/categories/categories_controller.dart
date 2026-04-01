import 'package:get/get.dart';
import 'package:tweet_vault_app/src/2_domain/dto/category_dto.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_category_service.dart';

class CategoriesController extends GetxController {
  final ICategoryService _categoryService;

  CategoriesController(this._categoryService);

  var categoriesRx = Rx<List<CategoryDto>>([]);
  var isLoadingRx = Rx<bool>(false);
  var errorRx = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    cargarCategorias();
  }

  /// Obtiene todas las categorías del usuario
  Future<void> cargarCategorias() async {
    isLoadingRx.value = true;
    errorRx.value = null;
    try {
      categoriesRx.value = await _categoryService.getCategories();
    } catch (e) {
      errorRx.value = e.toString();
    } finally {
      isLoadingRx.value = false;
    }
  }

  /// Crea una nueva categoría
  Future<void> crearCategoria(String name, String color) async {
    try {
      await _categoryService.createCategory(name, color);
      await cargarCategorias();
    } catch (e) {
      errorRx.value = e.toString();
    }
  }

  /// Actualiza nombre y color de una categoría
  Future<void> actualizarCategoria(String id, String name, String color) async {
    try {
      await _categoryService.updateCategory(id, name, color);
      await cargarCategorias();
    } catch (e) {
      errorRx.value = e.toString();
    }
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    try {
      await _categoryService.deleteCategory(id);
      await cargarCategorias();
    } catch (e) {
      errorRx.value = e.toString();
    }
  }

  /// Establece una categoría como predeterminada
  Future<void> establecerPorDefecto(String id) async {
    try {
      await _categoryService.setDefaultCategory(id);
      await cargarCategorias();
    } catch (e) {
      errorRx.value = e.toString();
    }
  }
}
