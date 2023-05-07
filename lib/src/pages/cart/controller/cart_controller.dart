import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/models/cart_item_model.dart";
import "package:greengrocer/src/models/item_model.dart";
import "package:greengrocer/src/models/order_model.dart";
import "package:greengrocer/src/pages/auth/controllers/auth_controller.dart";
import "package:greengrocer/src/pages/cart/cart_result/cart_result.dart";
import "package:greengrocer/src/pages/cart/repository/cart_repository.dart";
import "package:greengrocer/src/pages/widgets/payment_dialog.dart";
import "package:greengrocer/src/services/utils_services.dart";

class CartController extends GetxController {
  final CartRepository cartRepository = CartRepository();
  final AuthController authController = Get.find();
  final UtilsServices utilsServices = UtilsServices();

  List<CartItemModel> cartItems = <CartItemModel>[];
  bool isCheckoutLoading = false;

  @override
  void onInit() {
    super.onInit();
    this.getCartItems();
  }

  double cartTotalPrice() => this.cartItems.fold(0, (double previousValue, CartItemModel cartItem) => previousValue + cartItem.totalPrice());

  void setCheckoutLoading(bool value) {
    this.isCheckoutLoading = value;
    this.update();
  }

  Future<void> checkoutCart() async {
    this.setCheckoutLoading(true);

    CartResult<OrderModel> result = await this.cartRepository.checkoutCart(
      token: this.authController.user.token!,
      total: this.cartTotalPrice(),
    );

    this.setCheckoutLoading(false);

    result.when(
      success: (OrderModel order) {
        this.cartItems.clear();
        this.update();

        showDialog(
          context: Get.context!,
          builder: (_) => PaymentDialog(order: order)
        );
      },
      error: (String message) {
        this.utilsServices.showToast(message: message);
      }
    );
  }

  Future<bool> changeItemQuantity({
    required CartItemModel item,
    required int quantity
  }) async {
    final bool result = await this.cartRepository.changeItemQuantity(
      token: this.authController.user.token!,
      cartItemId: item.id,
      quantity: quantity
    );

    if (result) {
      quantity == 0
        ? this.cartItems.removeWhere((CartItemModel cartItem) => cartItem.id == item.id)
        : this.cartItems.firstWhere((CartItemModel cartItem) => cartItem.id == item.id).quantity = quantity;

      this.update();
    } else
      this.utilsServices.showToast(
        message: "Ocorreu um erro ao alterar a quantidade do produto",
        isError: true,
      );

    return result;
  }

  Future<void> getCartItems() async {
    final CartResult<List<CartItemModel>> result = await this.cartRepository.getCartItems(
      token: this.authController.user.token!,
      userId: this.authController.user.id!
    );

    result.when(
      success: (List<CartItemModel> data) {
        this.cartItems = data;
        this.update();
      },
      error: (String message) {
        this.utilsServices.showToast(message: message, isError: true);
      }
    );
  }

  int getItemIndex(ItemModel item) => this.cartItems.indexWhere((CartItemModel itemInList) => itemInList.item.id == item.id);

  Future<void> addItemToCart({required ItemModel item, int quantity = 1}) async {
    int itemIndex = this.getItemIndex(item);

    if (itemIndex >= 0) {
      final CartItemModel product = this.cartItems[itemIndex];
      await this.changeItemQuantity(item: product, quantity: (product.quantity + quantity));
    } else {
      final CartResult<String> result = await this.cartRepository.addItemToCart(
        userId: this.authController.user.id!,
        token: this.authController.user.token!,
        productId: item.id,
        quantity: quantity
      );

      result.when(
        success: (String cartItemId) {
          this.cartItems.add(CartItemModel(id: cartItemId, item: item, quantity: quantity));
        },
        error: (String message) {
          this.utilsServices.showToast(message: message, isError: true);
        }
      );
    }

    this.update();
  }
}