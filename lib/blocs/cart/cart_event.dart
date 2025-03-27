part of 'cart_bloc.dart';

abstract class CartEvent {}

class GetCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final int quantity;

  AddToCart({required this.productId, required this.quantity});
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;

  UpdateQuantity({required this.productId, required this.quantity});
}

class GetNextPageCart extends CartEvent {
  final int page;

  GetNextPageCart(this.page);
}

class Checkout extends CartEvent {
  final List cartId;

  Checkout(this.cartId);
}
