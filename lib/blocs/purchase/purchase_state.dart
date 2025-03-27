part of 'purchase_bloc.dart';

class PurchaseState {
  final UiState<List<HistoryPurchaseModel>> histories;
  final UiState<HistoryPurchaseModel> singleHistory;
  final UiState<String> actionState;

  const PurchaseState({
    required this.histories,
    required this.singleHistory,
    required this.actionState,
  });

  factory PurchaseState.initial() => PurchaseState(
    histories: const Loading(),
    singleHistory: const NotLogged(),
    actionState: const NotLogged(),
  );

  PurchaseState copyWith({
    UiState<List<HistoryPurchaseModel>>? histories,
    UiState<HistoryPurchaseModel>? singleHistory,
    UiState<String>? actionState,
  }) {
    return PurchaseState(
      histories: histories ?? this.histories,
      singleHistory: singleHistory ?? this.singleHistory,
      actionState: actionState ?? this.actionState,
    );
  }
}
