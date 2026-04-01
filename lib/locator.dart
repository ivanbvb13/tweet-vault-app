import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tweet_vault_app/src/2_domain/config/supabase_config.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_category_service.dart';
import 'package:tweet_vault_app/src/2_domain/service/interfaces/i_tweet_service.dart';
import 'package:tweet_vault_app/src/2_domain/service/category_service.dart';
import 'package:tweet_vault_app/src/2_domain/service/tweet_service.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/auth/auth_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/home/home_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/library/library_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/categories/categories_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/save_tweet/save_tweet_controller.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  locator.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  locator.registerFactory<ITweetService>(
      () => TweetService(locator<SupabaseClient>()));
  locator.registerFactory<ICategoryService>(
      () => CategoryService(locator<SupabaseClient>()));

  locator.registerFactory<HomeController>(() => HomeController(
        locator<ITweetService>(),
        locator<ICategoryService>(),
      ));
  locator.registerFactory<AuthController>(() => AuthController());
  locator.registerFactory<LibraryController>(() => LibraryController(
        locator<ITweetService>(),
        locator<ICategoryService>(),
      ));
  locator.registerFactory<CategoriesController>(() => CategoriesController(
        locator<ICategoryService>(),
      ));
  locator.registerFactory<SaveTweetController>(() => SaveTweetController(
        locator<ITweetService>(),
        locator<ICategoryService>(),
      ));
}
