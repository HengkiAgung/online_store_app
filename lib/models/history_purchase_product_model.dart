import 'package:online_stores_app/models/product_model.dart';

class HistoryPurchaseProductModel {
  final ProductModel product;
  final int quantity;
  final int price;
  final int totalPrice;

  HistoryPurchaseProductModel({
    required this.product,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory HistoryPurchaseProductModel.fromJson(Map<String, dynamic> json) {
    return HistoryPurchaseProductModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      price: json['price'],
      totalPrice: json['total_price'],
    );
  }
}
