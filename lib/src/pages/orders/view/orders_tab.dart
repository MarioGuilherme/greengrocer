import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/pages/orders/controller/all_orders_controller.dart";
import "package:greengrocer/src/pages/orders/view/widgets/order_tile.dart";

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos")
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (AllOrdersController controller) {
          return RefreshIndicator(
            onRefresh: () => controller.getAllOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: controller.allOrders.length,
              itemBuilder: (_, int index) => OrderTile(order: controller.allOrders[index])
            )
          ); 
        }
      )
    );
  }
}