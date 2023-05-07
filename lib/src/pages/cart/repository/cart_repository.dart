import "package:greengrocer/src/constants/endpoints.dart";
import "package:greengrocer/src/models/cart_item_model.dart";
import "package:greengrocer/src/models/order_model.dart";
import "package:greengrocer/src/pages/cart/cart_result/cart_result.dart";
import "package:greengrocer/src/services/http_manager.dart";

class CartRepository {
  final HttpManager _httpManager = HttpManager();

  Future<CartResult<List<CartItemModel>>> getCartItems({
    required String token,
    required String userId
  }) async {
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.getCartItems,
      method: HttpMethods.post,
      headers: <String, String>{
        "X-Parse-Session-Token": token
      },
      body: <String, String>{
        "user": userId
      }
    );

    if (response["result"] != null) {
      List<CartItemModel> data = List<Map<String, dynamic>>.from(response["result"]).map(CartItemModel.fromJson).toList();
      return CartResult<List<CartItemModel>>.success(data);
    }
    return CartResult<List<CartItemModel>>.error("Ocorreu um erro ao recuperar os itens do carrinho");
  }

  Future<CartResult<OrderModel>> checkoutCart({
    required String token,
    required double total
  }) async {
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.checkout,
      method: HttpMethods.post,
      body: <String, Object>{
        "total": total
      },
      headers: <String, String>{
        "X-Parse-Session-Token": token
      }
    );

    if (response["result"] != null) {
      final OrderModel order = OrderModel.fromJson(response["result"]);
      return CartResult<OrderModel>.success(order);
    }
    return CartResult<OrderModel>.error("Não possível realizar o pedido");
  }

  Future<bool> changeItemQuantity({
    required String token,
    required String cartItemId,
    required int quantity
  }) async {
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.changeItemQuantity,
      method: HttpMethods.post,
      body: <String, Object>{
        "cartItemId": cartItemId,
        "quantity": quantity
      },
      headers: <String, String>{
        "X-Parse-Session-Token": token
      }
    );

    return response.isEmpty;
  }

  Future<CartResult<String>> addItemToCart({
    required String userId,
    required String token,
    required String productId,
    required int quantity
  }) async {
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.addItemToCart,
      method: HttpMethods.post,
      body: <String, Object>{
        "user": userId,
        "quantity": quantity,
        "productId": productId
      },
      headers: <String, String>{
        "X-Parse-Session-Token": token
      }
    );

    if (response["result"] != null)
      return CartResult<String>.success(response["result"]["id"]);
    return CartResult<String>.error("Não foi possível adicionar o item no carrinho");
  }
}