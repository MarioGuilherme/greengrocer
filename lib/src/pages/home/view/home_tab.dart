import "package:add_to_cart_animation/add_to_cart_animation.dart";
import "package:add_to_cart_animation/add_to_cart_icon.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/config/custom_colors.dart";
import "package:greengrocer/src/models/item_model.dart";
import "package:greengrocer/src/pages/base/controller/navigation_controller.dart";
import "package:greengrocer/src/pages/cart/controller/cart_controller.dart";
import "package:greengrocer/src/pages/home/controller/home_controller.dart";
import "package:greengrocer/src/pages/home/view/widgets/category_tile.dart";
import "package:greengrocer/src/pages/home/view/widgets/item_tile.dart";
import "package:greengrocer/src/pages/widgets/app_name_widget.dart";
import "package:greengrocer/src/pages/widgets/custom_shimmer.dart";

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  final TextEditingController searchEC = TextEditingController();
  final NavigationController navigationController = Get.find();

  void itemSelectedCartAnimation(GlobalKey gkImage) {
    this.runAddToCartAnimation(gkImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GetBuilder<CartController>(
              builder: (CartController controller) {
                return GestureDetector(
                  onTap: () => this.navigationController.navigatorPageView(NavigationTabs.cart),
                  child: Badge(
                    backgroundColor: CustomColors.customContrastColor,
                    label: Text(
                      controller.cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, right: 15),
                      child: GestureDetector(
                        onDoubleTap: () {},
                        child: AddToCartIcon(
                          key: this.globalKeyCartItems,
                          icon: Icon(
                            Icons.shopping_cart,
                            color: CustomColors.customSwatchColor
                          )
                        )
                      )
                    )
                  )
                ); 
              }
            )
          )
        ]
      ),
      body: AddToCartAnimation(
        gkCart: this.globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        // ignore: always_specify_types
        receiveCreateAddToCardAnimationMethod: (addToCartAnimationMethod) {
          this.runAddToCartAnimation = addToCartAnimationMethod;
        },
        child: Column(
          children: <Widget>[
            GetBuilder<HomeController>(
              builder: (HomeController controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: this.searchEC,
                    onChanged: (String value) {
                      controller.searchTitle.value = value;
                    },
                    decoration: InputDecoration(
                      suffixIcon: controller.searchTitle.value.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.close, size: 21),
                          color: CustomColors.customContrastColor,
                          onPressed: () {
                            this.searchEC.clear();
                            controller.searchTitle.value = "";
                            FocusScope.of(context).unfocus();
                          }
                        )
                        : null,
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      hintText: "Pesquise aqui...",
                      hintStyle: const TextStyle(color: Color.fromARGB(255, 99, 35, 35), fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CustomColors.customContrastColor,
                        size: 21
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none
                        )
                      )
                    )
                  )
                ); 
              }
            ),
            GetBuilder<HomeController>(
              builder: (HomeController controller) {
                return Container(
                  padding: const EdgeInsets.only(left: 25),
                  height: 40,
                  child: !controller.isCategoryLoading
                    ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.allCategories.length,
                      separatorBuilder: (_, int index) => const SizedBox(width: 10),
                      itemBuilder: (_, int index) => CategoryTile(
                        onPressed: () {
                          controller.selectCategory(controller.allCategories[index]);
                        },
                        category: controller.allCategories[index].title,
                        isSelected: controller.allCategories[index] == controller.currentCategory
                      )
                    )
                  : ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Container>.generate(10, (_) => Container(
                      margin: const EdgeInsets.only(right: 12),
                      alignment: Alignment.center,
                      child: CustomShimmer(
                        height: 20,
                        width: 80,
                        borderRadius: BorderRadius.circular(20)
                      )
                    ))
                  )
                );
              }
            ),
            GetBuilder<HomeController>(
              builder: (HomeController controller) {
                return Expanded(
                  child: !controller.isProductLoading
                   ? Visibility(
                      visible: (controller.currentCategory?.items ?? <ItemModel>[]).isNotEmpty,
                      replacement: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.search_off, size: 40, color: CustomColors.customSwatchColor),
                          const Text("Não há items para apresentar")
                        ]
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 9 / 11.5
                        ),
                        itemCount: controller.allProducts.length,
                        itemBuilder: (_, int index) {
                          if (index + 1 == controller.allProducts.length && !controller.isLastPage) {
                            controller.loadMoreProducts();
                          }
                          return ItemTile(
                            item: controller.allProducts[index],
                            cartAnimationMethod: this.runAddToCartAnimation
                          );
                        }
                      ),
                   )
                  : GridView.count(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 9 / 11.5,
                      children: List<CustomShimmer>.generate(10, (_) => CustomShimmer(
                          height: double.infinity,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(20)
                        )
                      )
                    )
                ); 
              }
            )
          ]
        )
      )
    );
  }
}