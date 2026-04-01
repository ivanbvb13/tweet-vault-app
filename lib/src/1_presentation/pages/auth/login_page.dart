import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tweet_vault_app/locator.dart';
import 'package:tweet_vault_app/src/1_presentation/pages/auth/auth_controller.dart';
import 'package:tweet_vault_app/src/1_presentation/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Get.put(locator<AuthController>());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark,
                size: 80,
                color: AppTheme.darkTheme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Tweet Vault',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Guarda y organiza tus tweets',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),
              // Campo email con mensaje de error
              Obx(() => TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                      errorText: controller.errorRx.value,
                    ),
                  )),
              const SizedBox(height: 16),
              // Campo contraseña
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              // Botón de login
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isLoadingRx.value
                          ? null
                          : () async {
                              await controller.signIn(
                                emailController.text,
                                passwordController.text,
                              );
                              if (controller.isLoggedInRx.value) {
                                widget.onLoginSuccess();
                              }
                            },
                      child: controller.isLoadingRx.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Iniciar Sesión'),
                    ),
                  )),
              const SizedBox(height: 16),
              // Toggle entre login y registro
              Obx(() => TextButton(
                    onPressed: controller.isLoadingRx.value
                        ? null
                        : () {
                            controller.toggleSignUpMode();
                            if (controller.isSignUpRx.value) {
                              controller.signUp(
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                    child: Text(
                      controller.isSignUpRx.value
                          ? '¿Ya tienes cuenta? Inicia sesión'
                          : '¿No tienes cuenta? Regístrate',
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
