import 'package:get/get.dart';
import 'package:tweet_vault_app/src/2_domain/dto/category_dto.dart';
import 'package:tweet_vault_app/src/2_domain/dto/tweet_dto.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_category_service.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_tweet_service.dart';

class LibraryController extends GetxController {
  final ITweetService _tweetService;
  final ICategoryService _categoryService;

  LibraryController(this._tweetService, this._categoryService);

  var tweetsRx = Rx<List<TweetDto>>([]);
  var categoriesRx = Rx<List<CategoryDto>>([]);
  var selectedCategoryRx = Rx<String?>(null);
  var searchQueryRx = Rx<String>('');
  var isLoadingRx = Rx<bool>(false);
  var errorRx = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    cargarDatos();
  }

  /// Carga tweets y categorías desde Supabase
  Future<void> cargarDatos() async {
    isLoadingRx.value = true;
    errorRx.value = null;
    try {
      final results = await Future.wait([
        _tweetService.getTweets(),
        _categoryService.getCategories(),
      ]);
      tweetsRx.value = results[0] as List<TweetDto>;
      categoriesRx.value = results[1] as List<CategoryDto>;
    } catch (e) {
      errorRx.value = e.toString();
    } finally {
      isLoadingRx.value = false;
    }
  }

  /// Filtra tweets por categoría seleccionada
  Future<void> filtrarPorCategoria(String? categoryId) async {
    selectedCategoryRx.value = categoryId;
    isLoadingRx.value = true;
    try {
      if (categoryId == null) {
        tweetsRx.value = await _tweetService.getTweets();
      } else {
        tweetsRx.value = await _tweetService.getTweetsByCategory(categoryId);
      }
    } catch (e) {
      errorRx.value = e.toString();
    } finally {
      isLoadingRx.value = false;
    }
  }

  /// Busca tweets por texto, autor o handle
  Future<void> buscar(String query) async {
    searchQueryRx.value = query;
    if (query.isEmpty) {
      await cargarDatos();
      return;
    }
    isLoadingRx.value = true;
    try {
      tweetsRx.value = await _tweetService.searchTweets(query);
    } catch (e) {
      errorRx.value = e.toString();
    } finally {
      isLoadingRx.value = false;
    }
  }

  /// Elimina un tweet por su ID
  Future<void> eliminarTweet(String tweetId) async {
    try {
      await _tweetService.deleteTweet(tweetId);
      await cargarDatos();
    } catch (e) {
      errorRx.value = e.toString();
    }
  }
}
