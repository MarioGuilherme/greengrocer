import "package:get/get.dart";

import "package:greengrocer/src/models/category_model.dart";
import "package:greengrocer/src/models/item_model.dart";
import "package:greengrocer/src/pages/home/repository/home_repository.dart";
import "package:greengrocer/src/pages/home/result/home_result.dart";
import "package:greengrocer/src/services/utils_services.dart";

const int itemsPerPage = 6;

class HomeController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository();
  final UtilsServices _utilsServices = UtilsServices();
  bool isCategoryLoading = false;
  bool isProductLoading = true;
  List<CategoryModel> allCategories = <CategoryModel>[];
  CategoryModel? currentCategory;

  RxString searchTitle = "".obs;

  List<ItemModel> get allProducts => this.currentCategory?.items ?? <ItemModel>[];
  bool get isLastPage {
    if (this.currentCategory!.items.length < itemsPerPage)
      return true;
    return this.currentCategory!.pagination * itemsPerPage > this.allProducts.length;
  }

  @override
  void onInit() {
    super.onInit();
    debounce(
      this.searchTitle,
      (_) => this.filterByTitle(),
      time: const Duration(milliseconds: 600)
    );
    this.getAllCategories();
  }

  void setLoading(bool value, { bool isForProduct = false}) {
    if (isForProduct)
      this.isProductLoading = value;
    else
      this.isCategoryLoading = value;
    this.update();
  }
  
  void selectCategory(CategoryModel category) {
    this.currentCategory = category;
    update();
    if (this.currentCategory!.items.isNotEmpty) return;
    this.getAllProducts();
  }

  void filterByTitle() {
    for (CategoryModel category in this.allCategories) {
      category.items.clear();
      category.pagination = 0;
    }
    if (this.searchTitle.value.isEmpty)
      this.allCategories.removeAt(0);
    else {
      CategoryModel? c = this.allCategories.firstWhereOrNull((CategoryModel c) => c.id == "");
      if (c == null) {
        final CategoryModel allProductsCategories = CategoryModel(
          title: "Todos",
          id: "",
          items: <ItemModel>[],
          pagination: 0
        );
        this.allCategories.insert(0, allProductsCategories);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }
    this.currentCategory = this.allCategories.first;
    this.update();
    this.getAllProducts();
  }

  void loadMoreProducts() {
    this.currentCategory!.pagination++;
    this.getAllProducts(canLoad: false);
  }

  Future<void> getAllCategories() async {
    HomeResult<CategoryModel> result = await this._homeRepository.getAllCategories();
    this.setLoading(false);
    result.when(
      success: (List<CategoryModel> data) {
        this.allCategories.assignAll(data);
        if (data.isEmpty) return;
        this.selectCategory(data.first);
      },
      error: (String message) {
        this._utilsServices.showToast(message: message, isError: true);
      }
    );
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) this.setLoading(true, isForProduct: true);
    Map<String, dynamic> body = <String, dynamic>{
      "page": currentCategory!.pagination,
      "categoryId": currentCategory!.id,
      "itemsPerPage": itemsPerPage
    };
    if (this.searchTitle.value.isNotEmpty) {
      body["title"] = this.searchTitle.value;
      if (this.currentCategory!.id.isEmpty)
        body.remove("categoryId");
    }
    HomeResult<ItemModel> result = await this._homeRepository.getAllProducts(body);
    this.setLoading(false, isForProduct: true);
    result.when(
      success: (List<ItemModel> data) {
        this.currentCategory!.items.addAll(data);
      },
      error: (String message) {
        this._utilsServices.showToast(message: message, isError: true);
      }
    );
  }
}