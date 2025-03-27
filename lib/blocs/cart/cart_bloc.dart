import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_stores_app/blocs/common/ui_state.dart';
import 'package:online_stores_app/models/cart_model.dart';
import 'package:online_stores_app/models/history_purchase_model.dart';
import 'package:online_stores_app/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartState.initial()) {
    on<GetCart>(_onGetCart);
    on<GetNextPageCart>(_onGetNextPageCart);
    on<AddToCart>(_onAddToCart);
    on<Checkout>(_onCheckout);
    on<UpdateQuantity>(_onUpdateQuantity);
  }

  Future<void> _onGetCart(GetCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(cart: const Loading()));
    try {
      final cart = await cartRepository.getCart();

      emit(state.copyWith(cart: Success(cart)));
    } catch (e) {
      emit(state.copyWith(cart: Error(e.toString())));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(actionState: const Loading()));
    try {
      await cartRepository.addToCart(
        productId: event.productId,
        quantity: event.quantity,
      );

      emit(state.copyWith(actionState: Success("Added to cart")));
      add(GetCart()); // refresh list
    } catch (e) {
      emit(state.copyWith(actionState: Error(e.toString())));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(actionState: const Loading()));
    try {
      await cartRepository.updateQuantity(
        productId: event.productId,
        quantity: event.quantity,
      );

      emit(state.copyWith(actionState: Success("Removed from cart")));
      add(GetCart()); // refresh list
    } catch (e) {
      emit(state.copyWith(actionState: Error(e.toString())));
    }
  }

  Future<void> _onGetNextPageCart(
    GetNextPageCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(cart: const Loading()));
    try {
      final cart = await cartRepository.getCart(page: event.page);
      emit(state.copyWith(cart: Success(cart)));
    } catch (e) {
      emit(state.copyWith(cart: Error(e.toString())));
    }
  }

  Future<void> _onCheckout(Checkout event, Emitter<CartState> emit) async {
    emit(state.copyWith(actionState: const Loading()));
    try {
      final HistoryPurchaseModel history = await cartRepository.checkout(
        event.cartId,
      );

      emit(state.copyWith(actionState: Success("Checkout: ${history.status}")));
      add(GetCart()); // refresh list
    } catch (e) {
      emit(state.copyWith(actionState: Error(e.toString())));
    }
  }
}
