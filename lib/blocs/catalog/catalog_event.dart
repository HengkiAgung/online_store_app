part of 'catalog_bloc.dart';

abstract class CatalogEvent {}

class GetCatalog extends CatalogEvent {}

class GetProductById extends CatalogEvent {
  final String productId;

  GetProductById(this.productId);
}

// scroll pagenate event
class GetNextPage extends CatalogEvent {
  final int page;
  final String search;

  GetNextPage({required this.page, required this.search});
}

class SearchProduct extends CatalogEvent {
  final String name;

  SearchProduct(this.name);
}
