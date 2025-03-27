import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_stores_app/blocs/auth/auth_bloc.dart';
import 'package:online_stores_app/blocs/cart/cart_bloc.dart';
import 'package:online_stores_app/blocs/common/ui_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(GetCart());
  }

  List<Map<String, dynamic>> _cartItems = [];
  bool _initialized = false;
  final Map<String, Timer> _debounceTimers = {};

  double getTotalPrice() {
    return _cartItems.fold(0.0, (sum, item) {
      if (item['selected']) {
        return sum + (item['product'].price * item['quantity']);
      }
      return sum;
    });
  }

  void updateQuantity(int index, int change) {
    setState(() {
      _cartItems[index]['quantity'] += change;
      final productId = _cartItems[index]['product'].id.toString();

      if (_cartItems[index]['quantity'] < 1) {
        context.read<CartBloc>().add(
          UpdateQuantity(productId: productId, quantity: 0),
        );

        _cartItems.removeAt(index);
      } else {
        // Cancel previous debounce timer (if any)
        _debounceTimers[productId]?.cancel();

        // Set new debounce timer (e.g., 800ms)
        _debounceTimers[productId] = Timer(
          const Duration(milliseconds: 500),
          () {
            final quantity = _cartItems[index]['quantity'];
            context.read<CartBloc>().add(
              UpdateQuantity(productId: productId, quantity: quantity),
            );
          },
        );
      }
    });
  }

  void toggleSelection(int index, bool? value) {
    setState(() {
      _cartItems[index]['selected'] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (prev, curr) => prev.actionState != curr.actionState,
        listener: (context, state) {
          if (state.actionState is Error) {
            context.read<AuthBloc>().add(AuthCheck());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text((state.actionState as Error).message)),
            );
          }
        },
        builder: (context, state) {
          switch (state.cart) {
            case Loading():
              return const Center(child: CircularProgressIndicator());

            case Error(:final message):
              context.read<AuthBloc>().add(AuthCheck());
              return Center(child: Text('❌ $message'));

            case Success(:final data):
              if (data.isEmpty) {
                return const Center(child: Text('No product found. Add some!'));
              }

              if (!_initialized) {
                _cartItems = List<Map<String, dynamic>>.from(
                  data.map((item) {
                    final itemMap = item.toMap();
                    return {...itemMap, 'selected': true};
                  }),
                );
                _initialized = true;
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Checkbox(
                              value: item['selected'],
                              onChanged:
                                  (value) => toggleSelection(index, value),
                            ),
                            title: Text(item['product'].name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${(item['product'].price * item['quantity']).toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed:
                                          () => updateQuantity(index, -1),
                                    ),
                                    Text(item['quantity'].toString()),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => updateQuantity(index, 1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Image.network(
                              item['product'].image,
                              width: 60,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${getTotalPrice().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final selectedItems =
                              _cartItems
                                  .where((item) => item['selected'])
                                  .toList();

                          if (selectedItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select items to checkout.',
                                ),
                              ),
                            );
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Proceeding to checkout with ${selectedItems.length} items.',
                              ),
                            ),
                          );
                          final List selectedIds =
                              selectedItems.map((item) => item['id']).toList();
                          context.read<CartBloc>().add(Checkout(selectedIds));
                          context.read<CartBloc>().add(GetCart());
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Checkout'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );

            default:
              return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
