import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:online_stores_app/injection_container.dart';
import 'package:online_stores_app/pages/cart/cart_page.dart';
import 'package:online_stores_app/pages/catalog/catalog_detail_page.dart';
import 'package:online_stores_app/pages/purchase/history_page.dart';

import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/catalog/catalog_page.dart';
import '../layouts/auth_layout.dart';
import '../layouts/app_layout.dart';

final secureStorage = sl<FlutterSecureStorage>();

class AppRouter {
  static GoRouter generate(bool isLoggedIn) {
    return GoRouter(
      initialLocation: isLoggedIn ? '/catalog' : '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => AuthLayout(child: LoginPage()),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => AuthLayout(child: RegisterPage()),
        ),
        GoRoute(
          path: '/catalog',
          builder: (context, state) => AppLayout(child: CatalogPage()),
        ),
        GoRoute(
          path: '/catalog/:id',
          builder: (context, state) {
            final catalogId = state.pathParameters['id']!;
            return AppLayout(child: CatalogDetailPage(catalogId: catalogId));
          },
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => AppLayout(child: HistoryPage()),
        ),
        GoRoute(
          path: '/history/:id',
          builder: (context, state) {
            final catalogId = state.pathParameters['id']!;
            return AppLayout(child: CatalogDetailPage(catalogId: catalogId));
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => AppLayout(child: CartPage()),
        ),
      ],
    );
  }
}
