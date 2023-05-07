import "package:get/get.dart";

import "package:greengrocer/src/models/order_model.dart";
import "package:greengrocer/src/pages/auth/controllers/auth_controller.dart";
import "package:greengrocer/src/pages/orders/orders_result/order_result.dart";
import "package:greengrocer/src/pages/orders/repository/orders_repository.dart";
import "package:greengrocer/src/services/utils_services.dart";

class AllOrdersController extends GetxController {
  List<OrderModel> allOrders = <OrderModel>[];
  final OrdersRepository ordersRepository = OrdersRepository();
  final AuthController authController = Get.find();
  final UtilsServices utilsServices = UtilsServices();

  @override
  void onInit() {
    super.onInit();
    this.getAllOrders();
  }

  Future<void> getAllOrders() async {
    OrderResult<List<OrderModel>> result = await this.ordersRepository.getAllOrders(
      userId: this.authController.user.id!,
      token: this.authController.user.token!
    );

    result.when(
      success: (List<OrderModel> orders) {
        this.allOrders = orders..sort((OrderModel a, OrderModel b) => b.createdDateTime!.compareTo(a.createdDateTime!));
        this.update();
      },
      error: (String message) => this.utilsServices.showToast(message: message, isError: true)
    );
  }
}