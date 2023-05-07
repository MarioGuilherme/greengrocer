import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";

import "package:greengrocer/pages_routes/app_pages.dart";
import "package:greengrocer/src/pages/auth/controllers/auth_controller.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Greengrocer",
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white.withAlpha(190)
      ),
      initialRoute: PageRoutes.splashRoute,
      getPages: AppPages.pages
    );
  }
}