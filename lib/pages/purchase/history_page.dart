import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_stores_app/blocs/auth/auth_bloc.dart';
import 'package:online_stores_app/blocs/common/ui_state.dart';
import 'package:online_stores_app/blocs/purchase/purchase_bloc.dart';
import 'package:online_stores_app/models/history_purchase_model.dart';
import 'package:online_stores_app/models/history_purchase_product_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<PurchaseBloc>().add(GetHistories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase History')),
      body: BlocBuilder<PurchaseBloc, PurchaseState>(
        builder: (context, state) {
          switch (state.histories) {
            case Loading():
              return const Center(child: CircularProgressIndicator());

            case Error(:final message):
              context.read<AuthBloc>().add(AuthCheck());
              return Center(child: Text('❌ $message'));

            case Success(:final data):
              if (data.isEmpty) {
                return const Center(child: Text('No purchase history found.'));
              }

              final historyList = data;

              return ListView.builder(
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final history = historyList[index];
                  return _buildHistoryCard(history);
                },
              );
            default:
              return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildHistoryCard(HistoryPurchaseModel history) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      child: ExpansionTile(
        title: Text(
          'Status: ${history.status}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Total: \$${history.totalPrice} • Quantity: ${history.quantity}',
        ),
        children: [
          if (history.purchaseDate != null)
            _buildDateRow('Purchased:', history.purchaseDate!),
          if (history.paymentDate != null)
            _buildDateRow('Paid:', history.paymentDate!),
          if (history.shippingDate != null)
            _buildDateRow('Shipped:', history.shippingDate!),
          if (history.completedDate != null)
            _buildDateRow('Completed:', history.completedDate!),
          const Divider(),
          ...history.historyPurchaseProduct.map(_buildProductTile).toList(),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildProductTile(HistoryPurchaseProductModel item) {
    final product = item.product;
    return ListTile(
      onTap: () => context.push('/catalog/${product.id}'),
      leading: Image.network(
        product.image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      ),
      title: Text(product.name),
      subtitle: Text('${item.quantity} x \$${item.price}'),
      trailing: Text('\$${item.totalPrice}'),
    );
  }
}
