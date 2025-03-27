part of 'cart_bloc.dart';

class CartState {
  final UiState<List<CartModel>> cart;
  final UiState<String> actionState;

  const CartState({required this.cart, required this.actionState});

  factory CartState.initial() =>
      CartState(cart: const Loading(), actionState: const NotLogged());

  CartState copyWith({
    UiState<List<CartModel>>? cart,
    UiState<String>? actionState,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      actionState: actionState ?? this.actionState,
    );
  }
}
