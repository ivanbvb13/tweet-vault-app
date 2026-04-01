import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tweet_vault_app/locator.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/categories/categories_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/shared/category_chip.dart';
import 'package:tweet_vault_app/src/1_presentation/shared/loading_widget.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(locator<CategoriesController>());

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: Obx(() {
        // Estado: cargando
        if (controller.isLoadingRx.value) {
          return const LoadingWidget();
        }
        // Estado: error
        if (controller.errorRx.value != null) {
          return AppErrorWidget(
            message: controller.errorRx.value!,
            onRetry: controller.cargarCategorias,
          );
        }
        // Estado: sin categorías
        if (controller.categoriesRx.value.isEmpty) {
          return const EmptyWidget(
            message: 'No hay categorías\n\nCrea una para empezar',
            icon: Icons.category_outlined,
          );
        }
        // Lista de categorías
        return RefreshIndicator(
          onRefresh: controller.cargarCategorias,
          child: ListView.builder(
            itemCount: controller.categoriesRx.value.length,
            itemBuilder: (context, index) {
              final category = controller.categoriesRx.value[index];
              return CategoryListTile(
                category: category,
                onEdit: () => _showEditDialog(context, controller, category),
                onDelete: () => _confirmDelete(
                    context, controller, category.id, category.name),
                onSetDefault: () =>
                    controller.establecerPorDefecto(category.id),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Dialog para crear nueva categoría
  void _showCreateDialog(
      BuildContext context, CategoriesController controller) {
    final nameController = TextEditingController();
    String selectedColor = '#1DA1F2';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Nueva Categoría'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Color:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse('FF${color.substring(1)}', radix: 16)),
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  controller.crearCategoria(nameController.text, selectedColor);
                  Navigator.pop(context);
                }
              },
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog para editar categoría existente
  void _showEditDialog(
      BuildContext context, CategoriesController controller, dynamic category) {
    final nameController = TextEditingController(text: category.name);
    String selectedColor = category.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar Categoría'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Color:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse('FF${color.substring(1)}', radix: 16)),
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  controller.actualizarCategoria(
                      category.id, nameController.text, selectedColor);
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog de confirmación para eliminar
  void _confirmDelete(BuildContext context, CategoriesController controller,
      String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text(
            '¿Estás seguro de eliminar "$name"? Los tweets asociados no se eliminarán.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.eliminarCategoria(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  static const List<String> _colorOptions = [
    '#1DA1F2',
    '#E91E63',
    '#9C27B0',
    '#4CAF50',
    '#FF9800',
    '#F44336',
    '#00BCD4',
    '#795548',
  ];
}
