import "package:greengrocer/src/constants/endpoints.dart";
import "package:greengrocer/src/models/category_model.dart";
import "package:greengrocer/src/models/item_model.dart";
import "package:greengrocer/src/pages/home/result/home_result.dart";
import "package:greengrocer/src/services/http_manager.dart";

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.getAllCategories,
      method: HttpMethods.post
    );
    if (response["result"] == null) 
      return HomeResult<CategoryModel>.error("Ocorreu um erro inesperado ao recuperar as categorias");

    List<CategoryModel> categories = List<Map<String, dynamic>>.from(response["result"]).map(CategoryModel.fromJson).toList();
    return HomeResult<CategoryModel>.success(categories);
  }

  Future<HomeResult<ItemModel>> getAllProducts(Map<String, dynamic> body) async {
    Map<String, Object> body2 = <String, Object>{};
    body2["page"] = body["page"];
    body2["itemsPerPage"] = body["itemsPerPage"];
    if (body.keys.contains("categoryId")) body2["categoryId"] = body["categoryId"];
    if (body.keys.contains("title")) body2["title"] = body["title"];
    final Map<dynamic, dynamic> response = await this._httpManager.restRequest(
      endpoint: Endpoints.getAllProducts,
      method: HttpMethods.post,
      body: body2
    );
    if (response["result"] == null) 
      return HomeResult<ItemModel>.error("Ocorreu um erro inesperado ao recuperar os items");

    List<ItemModel> items = List<Map<String, dynamic>>.from(response["result"]).map(ItemModel.fromJson).toList();
    return HomeResult<ItemModel>.success(items);
  }
}