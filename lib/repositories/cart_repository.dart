import 'package:online_stores_app/models/cart_model.dart';
import 'package:online_stores_app/models/history_purchase_model.dart';
import 'package:online_stores_app/services/http_service.dart';
import 'package:online_stores_app/utils/constants.dart';

class CartRepository {
  final HttpService httpService;

  CartRepository({required this.httpService});

  Future<List<CartModel>> getCart({int page = 1}) async {
    final response = await httpService.get(
      ApiRoutes.getCart,
      parameters: {'page': page.toString()},
    );

    final List<dynamic> catalogJson = response['data'];

    return catalogJson.map((json) => CartModel.fromJson(json)).toList();
  }

  Future<CartModel> addToCart({
    required String productId,
    required int quantity,
  }) async {
    final response = await httpService.post(
      ApiRoutes.addToCart,
      body: {'product_id': productId, 'quantity': quantity},
    );

    return CartModel.fromJson(response['data']);
  }

  Future<String> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    final response = await httpService.post(
      ApiRoutes.updateQuantity,
      body: {'product_id': productId, 'quantity': quantity},
    );

    return response['status'];
  }

  Future<HistoryPurchaseModel> checkout(List cartId) async {
    final response = await httpService.post(
      ApiRoutes.checkout,
      body: {'cart_id': cartId},
    );

    return HistoryPurchaseModel.fromJson(response['data']);
  }
}
