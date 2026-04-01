import 'package:get/get.dart';
import 'package:tweet_vault_app/src/2_domain/dto/category_dto.dart';
import 'package:tweet_vault_app/src/2_domain/dto/tweet_dto.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_category_service.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_tweet_service.dart';

class HomeController extends GetxController {
  final ITweetService _tweetService;
  final ICategoryService _categoryService;

  HomeController(this._tweetService, this._categoryService);

  var tweetsRx = Rx<List<TweetDto>>([]);
  var categoriesRx = Rx<List<CategoryDto>>([]);
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

  /// Cambia la categoría de un tweet seleccionado
  Future<void> cambiarCategoria(String tweetId, String categoryId) async {
    try {
      await _tweetService.updateTweetCategory(tweetId, categoryId);
      await cargarDatos();
    } catch (e) {
      errorRx.value = e.toString();
    }
  }
}
