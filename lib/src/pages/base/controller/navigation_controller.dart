import "package:flutter/material.dart";
import "package:get/get.dart";

abstract class NavigationTabs {
  static const int home = 0;
  static const int cart = 1;
  static const int orders = 2;
  static const int profile = 3;
}

class NavigationController extends GetxController { 
  late PageController _pageController;
  late RxInt _currentIndex;

  PageController get pageController => this._pageController;
  int get currentIndex => this._currentIndex.value;

  @override
  void onInit() {
    super.onInit();
    this._initNavigation(
      pageController: PageController(initialPage: NavigationTabs.home),
      currentIndex: NavigationTabs.home
    );
  }

  void _initNavigation({
    required PageController pageController,
    required int currentIndex
  }) {
    this._pageController = pageController;
    this._currentIndex = currentIndex.obs;
  }

  void navigatorPageView(int page) {
    if (this._currentIndex.value == page) return;
    this._pageController.jumpToPage(page);
    this._currentIndex.value = page;
  }
}