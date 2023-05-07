import "package:get/get.dart";

import "package:greengrocer/src/models/cart_item_model.dart";
import "package:greengrocer/src/models/order_model.dart";
import "package:greengrocer/src/pages/auth/controllers/auth_controller.dart";
import "package:greengrocer/src/pages/orders/orders_result/order_result.dart";
import "package:greengrocer/src/pages/orders/repository/orders_repository.dart";
import "package:greengrocer/src/services/utils_services.dart";

class OrderController extends GetxController {
  final OrdersRepository ordersRepository = OrdersRepository();
  final AuthController authController = Get.find();
  final UtilsServices utilsServices = UtilsServices();
  OrderModel order;
  OrderController(this.order);
  bool isLoading = false;

  void setLoading(bool value) {
    this.isLoading = value;
    this.update();
  }

  Future<void> getOrderItems() async {
    setLoading(true);
    final OrderResult<List<CartItemModel>> result = await this.ordersRepository.getOrderItems(
      orderId: order.id,
      token: this.authController.user.token!
    );
    setLoading(false);

    result.when(
      success: (List<CartItemModel> items) {
        this.order.items = items;
        this.update();
      },
      error: (String message) {
        this.utilsServices.showToast(message: message, isError: true);
      }
    );
  }
}