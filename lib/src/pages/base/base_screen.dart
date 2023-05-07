import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/pages/base/controller/navigation_controller.dart";
import "package:greengrocer/src/pages/cart/view/cart_tab.dart";
import "package:greengrocer/src/pages/home/view/home_tab.dart";
import "package:greengrocer/src/pages/orders/view/orders_tab.dart";
import "package:greengrocer/src/pages/profile/profile_tab.dart";

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final NavigationController navigationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: this.navigationController.pageController,
        children: const <Widget>[
          HomeTab(),
          CartTab(),
          OrdersTab(),
          ProfileTab()
        ]
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: this.navigationController.currentIndex,
        onTap: (int indexPage) => this.navigationController.navigatorPageView(indexPage),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(100),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined)
          ),
          BottomNavigationBarItem(
            label: "Carrinho",
            icon: Icon(Icons.shopping_cart_outlined)
          ),
          BottomNavigationBarItem(
            label: "Pedidos",
            icon: Icon(Icons.list)
          ),
          BottomNavigationBarItem(
            label: "Perfil",
            icon: Icon(Icons.person_outline)
          )
        ]
      ))
    );
  }
}