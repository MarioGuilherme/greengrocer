import "package:get/get.dart";

import "package:greengrocer/src/pages/auth/views/sign_in_screen.dart";
import "package:greengrocer/src/pages/auth/views/sign_up_screen.dart";
import "package:greengrocer/src/pages/base/base_screen.dart";
import "package:greengrocer/src/pages/base/binding/navigation_binding.dart";
import "package:greengrocer/src/pages/cart/binding/cart_binding.dart";
import "package:greengrocer/src/pages/home/binding/home_binding.dart";
import "package:greengrocer/src/pages/orders/binding/order_binding.dart";
import "package:greengrocer/src/pages/product/product_screen.dart";
import "package:greengrocer/src/pages/splash/splash_screen.dart";

abstract class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<ProductScreen>(
      page: () => ProductScreen(),
      name: PageRoutes.productRoute
    ),
    GetPage<SplashScreen>(
      page: () => const SplashScreen(),
      name: PageRoutes.splashRoute
    ),
    GetPage<SignInScreen>(
      page: () => SignInScreen(),
      name: PageRoutes.signinRoute
    ),
    GetPage<SignUpScreen>(
      page: () => SignUpScreen(),
      name: PageRoutes.signupRoute
    ),
    GetPage<BaseScreen>(
      page: () => const BaseScreen(),
      name: PageRoutes.baseRoute,
      bindings: <Bindings>[
        NavigationBinding(),
        HomeBinding(),
        CartBinding(),
        OrdersBinding()
      ]
    )
  ];
}

abstract class PageRoutes {
  static const String productRoute = "/product";
  static const String signinRoute = "/signin";
  static const String signupRoute = "/signup";
  static const String splashRoute = "/splash";
  static const String baseRoute = "/";
}