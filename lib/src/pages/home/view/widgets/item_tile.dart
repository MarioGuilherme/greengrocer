import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/pages_routes/app_pages.dart";
import "package:greengrocer/src/config/custom_colors.dart";
import "package:greengrocer/src/models/item_model.dart";
import "package:greengrocer/src/pages/cart/controller/cart_controller.dart";
import "package:greengrocer/src/services/utils_services.dart";

class ItemTile extends StatefulWidget {
  final ItemModel item;
  final void Function(GlobalKey) cartAnimationMethod;

  const ItemTile({
    required this.item,
    required this.cartAnimationMethod,
    super.key
  });

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final GlobalKey imageGk = GlobalKey();
  final CartController cartController = Get.find();
  final UtilsServices utilsServices = UtilsServices();
  IconData tileIcon = Icons.add_shopping_cart_outlined;

  Future<void> switchIcon() async {
    setState(() => this.tileIcon = Icons.check);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    setState(() => this.tileIcon = Icons.add_shopping_cart_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Get.toNamed(PageRoutes.productRoute, arguments: this.widget.item);
          },
          child: Card(
            elevation: 1,
            shadowColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Hero(
                      tag: this.widget.item.imageUrl,
                      child: SizedBox(
                        child: Image.network(
                          this.widget.item.imageUrl,
                          key: this.imageGk
                        )
                      )
                    )
                  ),
                  Text(
                    this.widget.item.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        this.utilsServices.priceToCurrency(this.widget.item.price),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.customSwatchColor
                        )
                      ),
                      Text(
                        "/${widget.item.unit}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500
                        )
                      )
                    ]
                  )
                ]
              )
            )
          )
        ),
        Positioned(
          top: 4,
          right: 4,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(20)
            ),
            child: Material(
              child: InkWell(
                onTap: () async {
                  this.switchIcon();
                  await this.cartController.addItemToCart(item: this.widget.item);
                  this.widget.cartAnimationMethod(this.imageGk);
                },
                child: Ink(
                  height: 40,
                  width: 35,
                  decoration: BoxDecoration(color: CustomColors.customSwatchColor),
                  child: Icon(
                    this.tileIcon,
                    color: Colors.white,
                    size: 20
                  )
                )
              )
            )
          )
        )
      ]
    );
  }
}