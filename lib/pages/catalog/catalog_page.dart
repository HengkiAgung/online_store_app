import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_stores_app/blocs/auth/auth_bloc.dart';
import 'package:online_stores_app/blocs/catalog/catalog_bloc.dart';
import '../../blocs/common/ui_state.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(GetCatalog());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore) {
        _isLoadingMore = true;
        _currentPage++;
        context.read<CatalogBloc>().add(
          GetNextPage(page: _currentPage, search: _lastQuery),
        );
        Future.delayed(const Duration(seconds: 1), () {
          _isLoadingMore = false;
        });
      }
    });
  }

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _lastQuery = '';
  bool _isLoadingMore = false;
  int _currentPage = 1;

  void _onSearch(String value) {
    setState(() {
      _lastQuery = value;
      _currentPage = 1;
    });

    context.read<CatalogBloc>().add(SearchProduct(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          switch (state.catalog) {
            case Loading():
              return const Center(child: CircularProgressIndicator());

            case Error(:final message):
              context.read<AuthBloc>().add(AuthCheck());
              return Center(child: Text('❌ $message'));

            case Success(:final data):
              if (data.isEmpty) {
                return const Center(
                  child: Text('No product found. Contact Admin!'),
                );
              }

              return GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 👈 This makes it 2 columns
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio:
                      0.7, // Adjust this to your card's height/width
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final product = data[index];
                  return GestureDetector(
                    onTap: () => context.push('/catalog/${product.id}'),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              product.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

            default:
              return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => context.push('/catalog/create'), // Navigate to Create Catalog
        child: const Icon(Icons.add),
      ),
    );
  }
}
