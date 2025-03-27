import 'package:online_stores_app/models/history_purchase_model.dart';
import 'package:online_stores_app/models/product_model.dart';
import 'package:online_stores_app/services/http_service.dart';
import 'package:online_stores_app/utils/constants.dart';

class CatalogRepository {
  final HttpService httpService;

  CatalogRepository({required this.httpService});

  Future<List<ProductModel>> getCatalog({int page = 1, String? search}) async {
    final response = await httpService.get(
      ApiRoutes.getCatalog,
      parameters: {'page': page.toString(), 'search': search ?? ''},
    );

    final List<dynamic> catalogJson = response['data'];

    return catalogJson.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> getProductById(String productId) async {
    final response = await httpService.get(
      ApiRoutes.getDetailCatalog(productId),
    );

    return ProductModel.fromJson(response['data']);
  }

  Future<HistoryPurchaseModel> checkout(List cartId) async {
    final response = await httpService.post(
      ApiRoutes.checkout,
      body: {'cart_id': cartId},
    );

    return HistoryPurchaseModel.fromJson(response['data']);
  }
}
