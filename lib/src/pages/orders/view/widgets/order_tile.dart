import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/models/cart_item_model.dart";
import "package:greengrocer/src/models/order_model.dart";
import "package:greengrocer/src/pages/orders/controller/order_controller.dart";
import "package:greengrocer/src/pages/orders/view/widgets/order_status.dart";
import "package:greengrocer/src/pages/widgets/payment_dialog.dart";
import "package:greengrocer/src/services/utils_services.dart";

class OrderTile extends StatelessWidget {
  final UtilsServices utilsServices = UtilsServices();

  final OrderModel order;

  OrderTile({
    required this.order,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: GetBuilder<OrderController>(
          init: OrderController(this.order),
          global: false,
          builder: (OrderController controller) {
            return ExpansionTile(
              onExpansionChanged: (bool value) {
                if (value && this.order.items.isEmpty) controller.getOrderItems();
              },
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Pedido: ${this.order.id}"),
                  Text(
                    this.utilsServices.formatDateTime(this.order.createdDateTime!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black
                    )
                  )
                ]
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: controller.isLoading
                ? <Widget>[
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator()
                  )
                ]
                : <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 150,
                            child: ListView(
                              children: this.order.items.map(
                                (CartItemModel orderItem) => OrderItemWidget(utilsServices: utilsServices, orderItem: orderItem)
                              ).toList()
                            )
                          )
                        ),
                        VerticalDivider(
                          width: 8,
                          thickness: 2,
                          color: Colors.grey.shade300
                        ),
                        Expanded(
                          flex: 2,
                          child: OrderStatusWidget(
                            status: this.order.status,
                            isOverdue: this.order.overdueDateTime.isBefore(DateTime.now())
                          )
                        )
                      ]
                    )
                  ),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 20),
                      children: <TextSpan>[
                        const TextSpan(
                          text: "Total ",
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(text: this.utilsServices.priceToCurrency(this.order.total))
                      ]
                    )
                  ),
                  Visibility(
                    visible: this.order.status == "pending_payment" && !this.order.isOverDue,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => PaymentDialog(order: this.order)
                      ),
                      icon: Image.asset(
                        "assets/app_images/pix.png",
                        height: 18
                      ),
                      label: const Text("Ver QR Code Pix")
                    )
                  )
                ]
            );
          }
        )
      )
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final CartItemModel orderItem;

  const OrderItemWidget({
    super.key,
    required this.utilsServices,
    required this.orderItem
  });

  final UtilsServices utilsServices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            "${orderItem.quantity} ${orderItem.item.unit} ",
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          Expanded(
            child: Text(
              orderItem.item.itemName,
              style: const TextStyle(fontWeight: FontWeight.bold)
            )
          ),
          Text(
            this.utilsServices.priceToCurrency(orderItem.totalPrice()),
            style: const TextStyle(fontWeight: FontWeight.bold)
          )
        ]
      )
    );
  }
}