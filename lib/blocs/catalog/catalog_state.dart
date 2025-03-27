part of 'catalog_bloc.dart';

class CatalogState {
  final UiState<List<ProductModel>> catalog;
  final UiState<ProductModel> detailProduct;
  final UiState<String> actionState;
  String? searchName;

  CatalogState({
    required this.catalog,
    required this.detailProduct,
    required this.actionState,
    this.searchName,
  });

  factory CatalogState.initial() => CatalogState(
    catalog: const Loading(),
    detailProduct: const NotLogged(),
    actionState: const NotLogged(),
  );

  CatalogState copyWith({
    UiState<List<ProductModel>>? catalog,
    UiState<ProductModel>? detailProduct,
    UiState<String>? actionState,
    String? searchName,
  }) {
    return CatalogState(
      catalog: catalog ?? this.catalog,
      detailProduct: detailProduct ?? this.detailProduct,
      actionState: actionState ?? this.actionState,
      searchName: searchName ?? this.searchName,
    );
  }
}
