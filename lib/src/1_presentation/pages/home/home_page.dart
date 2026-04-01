import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tweet_vault_app/locator.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/auth/auth_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/home/home_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/library/library_page.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/categories/categories_page.dart';
import 'package:tweet_vault_app/src/1_presentation/shared/tweet_card.dart';
import 'package:tweet_vault_app/src/2_domain/helpers/navigator_helper.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onLogout;

  const HomePage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(locator<HomeController>());
    final authController = Get.put(locator<AuthController>());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet Vault'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) async {
              if (value == 'logout') {
                await authController.signOut();
                onLogout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        // Estado: cargando datos
        if (controller.isLoadingRx.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // Estado: error al cargar
        if (controller.errorRx.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  controller.errorRx.value!,
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: controller.cargarDatos,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }
        // Estado: sin tweets
        if (controller.tweetsRx.value.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No hay tweets guardados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Guarda tweets desde X para verlos aquí',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }
        // Lista de tweets
        return RefreshIndicator(
          onRefresh: controller.cargarDatos,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: controller.tweetsRx.value.length,
            itemBuilder: (context, index) {
              final tweet = controller.tweetsRx.value[index];
              final category = controller.categoriesRx.value.firstWhereOrNull(
                (c) => c.id == tweet.categoryId,
              );
              return TweetCard(
                tweet: tweet,
                categoryName: category?.name,
                categories: controller.categoriesRx.value,
                onTap: () => _openTweet(tweet.url),
                onChangeCategory: (categoryId) =>
                    controller.cambiarCategoria(tweet.tweetId, categoryId),
              );
            },
          ),
        );
      }),
      // Botones flotantes: categorías y biblioteca
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.small(
              heroTag: 'categories',
              onPressed: () => NavigatorHelper.pushWithSlideTransition(
                context,
                const CategoriesPage(),
              ),
              child: const Icon(Icons.category_outlined),
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              heroTag: 'library',
              onPressed: () => NavigatorHelper.pushWithSlideTransition(
                context,
                const LibraryPage(),
              ),
              child: const Icon(Icons.grid_view),
            ),
          ],
        ),
      ),
    );
  }

  /// Abre el tweet en el navegador externo
  Future<void> _openTweet(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
