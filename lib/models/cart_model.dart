import 'package:online_stores_app/models/product_model.dart';

class CartModel {
  final int id;
  final ProductModel product;
  final int quantity;

  CartModel({required this.id, required this.product, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'id': id, 'product': product, 'quantity': quantity};
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final product = ProductModel.fromJson(json['product']);

    return CartModel(
      id: json['id'],
      product: product,
      quantity: json['quantity'],
    );
  }
}
