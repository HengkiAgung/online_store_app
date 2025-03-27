import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_stores_app/blocs/common/ui_state.dart';
import 'package:online_stores_app/models/history_purchase_model.dart';
import 'package:online_stores_app/models/product_model.dart';
import 'package:online_stores_app/repositories/purchase_repository.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository purchaseRepository;

  PurchaseBloc({required this.purchaseRepository})
    : super(PurchaseState.initial()) {
    on<GetHistories>(_onGetHistories);
    on<GetHistoryById>(_onGetHistoryById);
    on<GetNextPageHistory>(_onGetNextPageHistory);
  }

  Future<void> _onGetHistories(
    GetHistories event,
    Emitter<PurchaseState> emit,
  ) async {
    emit(state.copyWith(histories: const Loading()));
    try {
      final histories = await purchaseRepository.getHistories();
      emit(state.copyWith(histories: Success(histories)));
    } catch (e) {
      emit(state.copyWith(histories: Error(e.toString())));
    }
  }

  Future<void> _onGetHistoryById(
    GetHistoryById event,
    Emitter<PurchaseState> emit,
  ) async {
    if (state.singleHistory is Success<ProductModel> &&
        (state.singleHistory as Success<ProductModel>).data.id ==
            event.historyId) {
      return;
    }

    emit(state.copyWith(singleHistory: const Loading()));
    try {
      final history = await purchaseRepository.getHistoryById(event.historyId);
      emit(state.copyWith(singleHistory: Success(history)));
    } catch (e) {
      emit(state.copyWith(singleHistory: Error(e.toString())));
    }
  }

  Future<void> _onGetNextPageHistory(
    GetNextPageHistory event,
    Emitter<PurchaseState> emit,
  ) async {
    emit(state.copyWith(histories: const Loading()));
    try {
      final histories = await purchaseRepository.getHistories(page: event.page);
      emit(state.copyWith(histories: Success(histories)));
    } catch (e) {
      emit(state.copyWith(histories: Error(e.toString())));
    }
  }
}
