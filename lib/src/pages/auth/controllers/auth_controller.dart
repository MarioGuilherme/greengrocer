import "package:get/get.dart";

import "package:greengrocer/pages_routes/app_pages.dart";
import "package:greengrocer/src/constants/storages_keys.dart";
import "package:greengrocer/src/models/user_model.dart";
import "package:greengrocer/src/pages/auth/repositories/auth_repository.dart";
import "package:greengrocer/src/pages/auth/result/auth_result.dart";
import "package:greengrocer/src/services/utils_services.dart";

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final AuthRepository _authRepository = AuthRepository();
  final UtilsServices _utilsServices = UtilsServices();

  UserModel user = UserModel();

  @override
  void onInit() {
    super.onInit();
    this.validateToken();
  }

  Future<void> validateToken() async {
    String? token = await this._utilsServices.getLocalData(key: StorageKeys.token);
    if (token == null) {
      Get.offAllNamed(PageRoutes.signinRoute);
      return;
    }
    AuthResult result = await this._authRepository.validateToken(token);
    result.when(
      success: (UserModel user) {
        this.user = user;
        saveTokenAndProceedToBase();
      },
      error: (String message) {
        signOut();
      }
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword
  }) async {
    this.isLoading.value = true;

    final bool result = await this._authRepository.changePassword(
      email: this.user.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
      token: this.user.token!
    );

    this.isLoading.value = false;

    if (result) {
      this._utilsServices.showToast(message: "A senha foi atualizada com sucesso!");
      this.signOut();
    } else
      this._utilsServices.showToast(message: "A senha atual está incorreta", isError: true);
  }

  Future<void> signOut() async {
    this.user = UserModel();
    await this._utilsServices.removeLocalData(key: StorageKeys.token);
    Get.offAllNamed(PageRoutes.signinRoute);
  }

  void saveTokenAndProceedToBase() {
    this._utilsServices.saveLocalData(key: StorageKeys.token, value: this.user.token!);
    Get.offAllNamed(PageRoutes.baseRoute);
  }

  Future<void> signUp() async {
    this.isLoading.value = true;
    AuthResult result = await this._authRepository.signUp(user);
    this.isLoading.value = false;
    result.when(
      success: (UserModel user) {
        this.user = user;
        saveTokenAndProceedToBase();
      },
      error: (String message) {
        this._utilsServices.showToast(message: message, isError: true);
      }
    );
  }

  Future<void> signin({required String email, required String password}) async {
    this.isLoading.value = true;
    AuthResult result = await this._authRepository.signIn(email: email, password: password);
    this.isLoading.value = false;
    result.when(
      success: (UserModel user) {
        this.user = user;
        saveTokenAndProceedToBase();
      },
      error: (String message) {
        this._utilsServices.showToast(message: message, isError: true);
      }
    );
  }

  Future<void> resetPassword(String email) async {
    await this._authRepository.resetPassword(email);
  }
}