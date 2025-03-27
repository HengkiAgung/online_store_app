part of 'purchase_bloc.dart';

sealed class PurchaseEvent {}

class GetHistories extends PurchaseEvent {}

class GetHistoryById extends PurchaseEvent {
  final String historyId;

  GetHistoryById(this.historyId);
}

class GetNextPageHistory extends PurchaseEvent {
  final int page;

  GetNextPageHistory(this.page);
}

class GetNextPageCart extends PurchaseEvent {
  final int page;

  GetNextPageCart(this.page);
}
