import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_stores_app/blocs/auth/auth_bloc.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Klontong'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: child,
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Catalog'),
              onTap: () => context.go('/catalog'),
            ),
            ListTile(
              title: const Text('History'),
              onTap: () => context.go('/history'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());

                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
