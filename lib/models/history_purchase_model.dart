import 'package:online_stores_app/models/history_purchase_product_model.dart';

class HistoryPurchaseModel {
  final List<HistoryPurchaseProductModel> historyPurchaseProduct;
  final int quantity;
  final int totalPrice;
  final String status;
  final String? purchaseDate;
  final String? paymentDate;
  final String? shippingDate;
  final String? completedDate;

  HistoryPurchaseModel({
    required this.historyPurchaseProduct,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    this.purchaseDate,
    this.paymentDate,
    this.shippingDate,
    this.completedDate,
  });

  factory HistoryPurchaseModel.fromJson(Map<String, dynamic> json) {
    // generate HistoryPurchaseProductModel from json['historyPurchaseProduct']
    final List<HistoryPurchaseProductModel> historyPurchaseProduct =
        (json['history_purchase_products'] as List<dynamic>)
            .map((product) => HistoryPurchaseProductModel.fromJson(product))
            .toList();

    return HistoryPurchaseModel(
      historyPurchaseProduct: historyPurchaseProduct,
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      status: json['status'],
      purchaseDate: json['purchase_date'],
      paymentDate: json['payment_date'],
      shippingDate: json['shipping_date'],
      completedDate: json['completed_date'],
    );
  }
}
