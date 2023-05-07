import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/config/custom_colors.dart";
import "package:greengrocer/src/models/item_model.dart";
import "package:greengrocer/src/pages/base/controller/navigation_controller.dart";
import "package:greengrocer/src/pages/cart/controller/cart_controller.dart";
import "package:greengrocer/src/pages/widgets/quantity_widget.dart";
import "package:greengrocer/src/services/utils_services.dart";

class ProductScreen extends StatefulWidget {
  final ItemModel item = Get.arguments;

  ProductScreen({ super.key });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final CartController cartController = Get.find();
  final NavigationController navigationController = Get.find();
  final UtilsServices utilsServices = UtilsServices();
  int cartItemQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: this.widget.item.imageUrl,
                  child: Image.network(this.widget.item.imageUrl)
                )
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.shade600,
                        offset: const Offset(0, 2)
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              this.widget.item.itemName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold
                              )
                            )
                          ),
                          QuantityWidget(
                            sufixText: this.widget.item.unit,
                            value: this.cartItemQuantity,
                            result: (int quantity) {
                              setState(() => this.cartItemQuantity = quantity);
                            }
                          )
                        ]
                      ),
                      Text(
                        this.utilsServices.priceToCurrency(this.widget.item.price),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.customSwatchColor
                        )
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SingleChildScrollView(
                            child: Text(
                              this.widget.item.description,
                              style: const TextStyle(height: 1.5)
                            )
                          )
                        )
                      ),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                          ),
                          onPressed: () async {
                            Get.back();
                            await this.cartController.addItemToCart(
                              item: this.widget.item,
                              quantity: this.cartItemQuantity
                            );
                            this.navigationController.navigatorPageView(NavigationTabs.cart);
                          },
                          label: const Text(
                            "Adicionar ao carrinho",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white
                          )
                        )
                      )
                    ]
                  )
                )
              )
            ]
          ),
          Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios)
              )
            )
          )
        ]
      )
    );
  }
}