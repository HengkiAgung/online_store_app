import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_stores_app/blocs/common/ui_state.dart';
import 'package:online_stores_app/models/product_model.dart';
import 'package:online_stores_app/repositories/catalog_repository.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogRepository catalogRepository;

  CatalogBloc({required this.catalogRepository})
    : super(CatalogState.initial()) {
    on<GetCatalog>(_onGetCatalog);
    on<GetProductById>(_onGetProductById);
    on<GetNextPage>(_onGetNextPage);
    on<SearchProduct>(_onSearchProduct);
  }

  Future<void> _onGetCatalog(
    GetCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(catalog: const Loading()));
    try {
      final catalog = await catalogRepository.getCatalog();
      emit(state.copyWith(catalog: Success(catalog)));
    } catch (e) {
      emit(state.copyWith(catalog: Error(e.toString())));
    }
  }

  Future<void> _onGetProductById(
    GetProductById event,
    Emitter<CatalogState> emit,
  ) async {
    if (state.detailProduct is Success<ProductModel> &&
        (state.detailProduct as Success<ProductModel>).data.id ==
            event.productId) {
      return;
    }

    emit(state.copyWith(detailProduct: const Loading()));
    try {
      final product = await catalogRepository.getProductById(event.productId);
      emit(state.copyWith(detailProduct: Success(product)));
    } catch (e) {
      emit(state.copyWith(detailProduct: Error(e.toString())));
    }
  }

  Future<void> _onGetNextPage(
    GetNextPage event,
    Emitter<CatalogState> emit,
  ) async {
    try {
      List<ProductModel> currentCatalog =
          state.catalog is Success<List<ProductModel>>
              ? (state.catalog as Success<List<ProductModel>>).data
              : [];
      final catalog = await catalogRepository.getCatalog(
        page: event.page,
        search: state.searchName,
      );

      // Add new products to the existing list
      currentCatalog.addAll(catalog);

      emit(state.copyWith(catalog: Success(currentCatalog)));
    } catch (e) {
      emit(state.copyWith(catalog: Error(e.toString())));
    }
  }

  Future<void> _onSearchProduct(
    SearchProduct event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(catalog: const Loading()));
    try {
      final catalog = await catalogRepository.getCatalog(search: event.name);
      emit(state.copyWith(catalog: Success(catalog), searchName: event.name));
    } catch (e) {
      emit(state.copyWith(catalog: Error(e.toString())));
    }
  }
}
