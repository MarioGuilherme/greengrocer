import "package:greengrocer/src/constants/endpoints.dart";
import "package:greengrocer/src/models/user_model.dart";
import "package:greengrocer/src/pages/auth/repositories/auth_errors.dart";
import "package:greengrocer/src/pages/auth/result/auth_result.dart";
import "package:greengrocer/src/services/http_manager.dart";

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> response) {
    if (response["result"] != null) {
      final UserModel user = UserModel.fromJson(response["result"]);
      return AuthResult.success(user);
    }
    return AuthResult.error(authErrorsString(response["error"]));
  }

  Future<AuthResult> validateToken(String token) async {
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.validateToken,
      method: HttpMethods.post,
      headers: <String, String>{
        "X-Parse-Session-Token": token
      }
    );
    return this.handleUserOrError(response);
  }

  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String token
  }) async {
    final Map<dynamic, dynamic> result = await this._httpManager.restRequest(
      endpoint: Endpoints.changePassword,
      method: HttpMethods.post,
      body: <String, String>{
        "email": email,
        "currentPassword": currentPassword,
        "newPassword": newPassword
      },
      headers: <String, String>{
        "X-Parse-Session-Token": token
      }
    );

    return result["error"] == null;
  }

  Future<AuthResult> signIn({required String email, required String password}) async {
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.signin,
      method: HttpMethods.post,
      body: <String, String>{
        "email": email,
        "password": password
      }
    );
    return this.handleUserOrError(response);
  }

  Future<AuthResult> signUp(UserModel user) async {
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.signup,
      method: HttpMethods.post,
      body: <String, String>{
        "id": user.id ?? "",
        "fullname": user.name ?? "",
        "email": user.email ?? "",
        "phone": user.phone ?? "",
        "cpf": user.cpf ?? "",
        "password": user.password ?? "",
        "token": user.token ?? ""
      }
    );
    return this.handleUserOrError(response);
  }

  Future<void> resetPassword(String email) async {
    await this._httpManager.restRequest(
      endpoint: Endpoints.resetPassword,
      method: HttpMethods.post,
      body: <String, String>{ "email": email }
    );
  }
}