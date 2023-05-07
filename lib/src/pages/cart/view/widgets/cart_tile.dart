import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/config/custom_colors.dart";
import "package:greengrocer/src/models/cart_item_model.dart";
import "package:greengrocer/src/pages/cart/controller/cart_controller.dart";
import "package:greengrocer/src/pages/widgets/quantity_widget.dart";
import "package:greengrocer/src/services/utils_services.dart";

class CartTile extends StatefulWidget {
  final CartItemModel cartItem;

  const CartTile({
    required this.cartItem,
    super.key
  });

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final CartController cartController = Get.find();
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Image.network(
          this.widget.cartItem.item.imageUrl,
          height: 60,
          width: 60
        ),
        title: Text(
          this.widget.cartItem.item.itemName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          this.utilsServices.priceToCurrency(this.widget.cartItem.totalPrice()),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold
          )
        ),
        trailing: QuantityWidget(
          sufixText: this.widget.cartItem.item.unit,
          value: this.widget.cartItem.quantity,
          result: (int quantity) {
            this.cartController.changeItemQuantity(
              item: this.widget.cartItem,
              quantity: quantity
            );
          },
          isRemovable: true
        )
      )
    );
  }
}