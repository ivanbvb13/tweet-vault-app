import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tweet_vault_app/locator.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/save_tweet/save_tweet_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/shared/category_chip.dart';
import 'package:tweet_vault_app/src/1_presentation/shared/loading_widget.dart';

class SaveTweetPage extends StatelessWidget {
  final String tweetUrl;

  const SaveTweetPage({super.key, required this.tweetUrl});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(locator<SaveTweetController>());
    controller.setTweetUrl(tweetUrl);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Obx(() {
            // Estado: guardando tweet
            if (controller.isLoadingRx.value && !controller.isSavedRx.value) {
              return const LoadingWidget(message: 'Guardando tweet...');
            }
            // Estado: tweet guardado exitosamente
            if (controller.isSavedRx.value) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '¡Tweet guardado!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'El tweet se ha guardado en tu biblioteca',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            }
            // Formulario de guardado
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle del tweet
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Guardar Tweet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Desde: ${controller.handle ?? 'Desconocido'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  // Mensaje de error
                  if (controller.errorRx.value != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.errorRx.value!,
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Text(
                    'Selecciona una categoría:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  // Selector de categoría
                  Obx(() {
                    if (controller.categoriesRx.value.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'No hay categorías. Crea una en la app primero.',
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.categoriesRx.value.map((category) {
                        return CategoryChip(
                          category: category,
                          isSelected: controller.selectedCategoryRx.value ==
                              category.id,
                          onTap: () => controller.selectCategory(category.id),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 32),
                  // Botón guardar
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.isLoadingRx.value
                              ? null
                              : controller.guardarTweet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: controller.isLoadingRx.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  'Guardar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      )),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
