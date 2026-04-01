import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final _client = Supabase.instance.client;

  var isLoadingRx = Rx<bool>(false);
  var errorRx = Rx<String?>(null);
  var isLoggedInRx = Rx<bool>(false);
  var isSignUpRx = Rx<bool>(false);

  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  void _checkSession() {
    final session = _client.auth.currentSession;
    isLoggedInRx.value = session != null;
  }

  Future<void> signIn(String email, String password) async {
    isLoadingRx.value = true;
    errorRx.value = null;
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      isLoggedInRx.value = true;
    } catch (e) {
      errorRx.value = 'Error al iniciar sesión: ${e.toString()}';
    } finally {
      isLoadingRx.value = false;
    }
  }

  Future<void> signUp(String email, String password) async {
    isLoadingRx.value = true;
    errorRx.value = null;
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
      );
      errorRx.value = 'Revisa tu correo para confirmar el registro';
    } catch (e) {
      errorRx.value = 'Error al registrarse: ${e.toString()}';
    } finally {
      isLoadingRx.value = false;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    isLoggedInRx.value = false;
  }

  void toggleSignUpMode() {
    isSignUpRx.value = !isSignUpRx.value;
  }
}
