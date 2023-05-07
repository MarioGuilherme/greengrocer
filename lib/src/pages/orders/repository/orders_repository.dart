import "package:greengrocer/src/constants/endpoints.dart";
import "package:greengrocer/src/models/cart_item_model.dart";
import "package:greengrocer/src/models/order_model.dart";
import "package:greengrocer/src/pages/orders/orders_result/order_result.dart";
import "package:greengrocer/src/services/http_manager.dart";

class OrdersRepository {
  final HttpManager _httpManager = HttpManager();

  Future<OrderResult<List<CartItemModel>>> getOrderItems({
    required String orderId,
    required String token
  }) async {
    final Map<dynamic, dynamic> result = await this._httpManager.restRequest(
      endpoint: Endpoints.getOrderItems,
      method: HttpMethods.post,
      body: <String, String>{
        "orderId": orderId
      },
      headers: <String, String>{
        "X-Parse-Session-Token": token
      }
    );

    if (result["result"] != null) {
      List<CartItemModel> items = List<Map<String, dynamic>>.from(result["result"]).map(CartItemModel.fromJson).toList();
      return OrderResult<List<CartItemModel>>.success(items);
    }
    return OrderResult<List<CartItemModel>>.error("Não foi possível recuperar os produtos do pedido");
  }

  Future<OrderResult<List<OrderModel>>> getAllOrders({
    required String userId,
    required String token
  }) async {
    final Map<dynamic, dynamic> result = await this._httpManager.restRequest(
      endpoint: Endpoints.getAllOrders,
      method: HttpMethods.post,
      body: <String, String>{
        "user": userId
      },
      headers: <String, String>{
        "X-Parse-Session-Token": token
      }
    );

    if (result["result"] != null) {
      List<OrderModel> orders = List<Map<String, dynamic>>.from(result["result"]).map(OrderModel.fromJson).toList();
      return OrderResult<List<OrderModel>>.success(orders);
    }
    return OrderResult<List<OrderModel>>.error("Não foi possível recuperar os pedidos");
  }
}