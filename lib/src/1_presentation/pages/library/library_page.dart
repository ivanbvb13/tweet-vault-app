import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tweet_vault_app/locator.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/library/library_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/shared/tweet_card.dart';
import 'package:tweet_vault_app/src/1_presentation/shared/category_chip.dart';
import 'package:tweet_vault_app/src/1_presentation/shared/loading_widget.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(locator<LibraryController>());
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca'),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por texto o autor...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    controller.buscar('');
                  },
                ),
              ),
              onChanged: controller.buscar,
            ),
          ),
          // Filtro por categorías
          SizedBox(
            height: 50,
            child: Obx(() {
              if (controller.categoriesRx.value.isEmpty) {
                return const SizedBox();
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('Todos'),
                      selected: controller.selectedCategoryRx.value == null,
                      onSelected: (_) => controller.filtrarPorCategoria(null),
                    ),
                  ),
                  ...controller.categoriesRx.value.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryChip(
                        category: category,
                        isSelected:
                            controller.selectedCategoryRx.value == category.id,
                        onTap: () =>
                            controller.filtrarPorCategoria(category.id),
                      ),
                    );
                  }),
                ],
              );
            }),
          ),
          const SizedBox(height: 8),
          // Lista de tweets
          Expanded(
            child: Obx(() {
              // Estado: cargando
              if (controller.isLoadingRx.value) {
                return const LoadingWidget();
              }
              // Estado: error
              if (controller.errorRx.value != null) {
                return AppErrorWidget(
                  message: controller.errorRx.value!,
                  onRetry: controller.cargarDatos,
                );
              }
              // Estado: sin resultados
              if (controller.tweetsRx.value.isEmpty) {
                return const EmptyWidget(
                  message: 'No se encontraron tweets',
                  icon: Icons.search_off,
                );
              }
              // Lista con swipe para eliminar
              return RefreshIndicator(
                onRefresh: controller.cargarDatos,
                child: ListView.builder(
                  itemCount: controller.tweetsRx.value.length,
                  itemBuilder: (context, index) {
                    final tweet = controller.tweetsRx.value[index];
                    final category =
                        controller.categoriesRx.value.firstWhereOrNull(
                      (c) => c.id == tweet.categoryId,
                    );
                    return Dismissible(
                      key: Key(tweet.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Eliminar tweet'),
                            content: const Text(
                                '¿Estás seguro de eliminar este tweet?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) =>
                          controller.eliminarTweet(tweet.tweetId),
                      child: TweetCard(
                        tweet: tweet,
                        categoryName: category?.name,
                        onTap: () => _openTweet(tweet.url),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
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
