import 'package:get/get.dart';
import 'package:tweet_vault_app/src/2_domain/dto/category_dto.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_category_service.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_tweet_service.dart';
import 'package:tweet_vault_app/src/2_domain/helpers/tweet_url_parser.dart';

class SaveTweetController extends GetxController {
  final ITweetService _tweetService;
  final ICategoryService _categoryService;

  SaveTweetController(this._tweetService, this._categoryService);

  var categoriesRx = Rx<List<CategoryDto>>([]);
  var selectedCategoryRx = Rx<String?>(null);
  var isLoadingRx = Rx<bool>(false);
  var isSavedRx = Rx<bool>(false);
  var errorRx = Rx<String?>(null);

  String? tweetId;
  String? url;
  String? text;
  String? author;
  String? handle;
  DateTime? publishedAt;
  List<String>? images;

  /// Extrae tweetId y handle de la URL compartida
  void setTweetUrl(String tweetUrl) {
    final parsed = TweetUrlParser.parse(tweetUrl);
    if (parsed != null) {
      url = tweetUrl;
      tweetId = parsed.tweetId;
      handle = parsed.username;
      author = '@${parsed.username}';
    } else {
      errorRx.value = 'URL de tweet inválida';
    }
  }

  @override
  void onInit() {
    super.onInit();
    cargarCategorias();
  }

  /// Obtiene categorías y selecciona la predeterminada
  Future<void> cargarCategorias() async {
    try {
      categoriesRx.value = await _categoryService.getCategories();
      final defaultCategory = categoriesRx.value.firstWhereOrNull(
        (c) => c.isDefault,
      );
      if (defaultCategory != null) {
        selectedCategoryRx.value = defaultCategory.id;
      }
    } catch (e) {
      errorRx.value = e.toString();
    }
  }

  /// Selecciona categoría para el tweet
  void selectCategory(String? categoryId) {
    selectedCategoryRx.value = categoryId;
  }

  /// Guarda el tweet en Supabase
  Future<void> guardarTweet() async {
    if (tweetId == null || url == null) {
      errorRx.value = 'Datos del tweet incompletos';
      return;
    }

    isLoadingRx.value = true;
    errorRx.value = null;
    try {
      await _tweetService.saveTweet(
        tweetId: tweetId!,
        url: url!,
        text: text,
        author: author,
        handle: handle,
        publishedAt: publishedAt,
        categoryId: selectedCategoryRx.value,
        images: images,
      );
      isSavedRx.value = true;
    } catch (e) {
      errorRx.value = e.toString();
    } finally {
      isLoadingRx.value = false;
    }
  }
}
