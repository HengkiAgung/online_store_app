import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:online_stores_app/blocs/auth/auth_bloc.dart';
import 'package:online_stores_app/blocs/cart/cart_bloc.dart';
import 'package:online_stores_app/blocs/catalog/catalog_bloc.dart';
import 'package:online_stores_app/blocs/purchase/purchase_bloc.dart';
import 'package:online_stores_app/repositories/auth_repository.dart';
import 'package:online_stores_app/repositories/cart_repository.dart';
import 'package:online_stores_app/repositories/catalog_repository.dart';
import 'package:online_stores_app/repositories/purchase_repository.dart';
import 'injection_container.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // DI init

  final storage = sl<FlutterSecureStorage>();
  final token = await storage.read(key: 'accessToken');
  final bool isLoggedIn = token != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  AuthBloc(authRepository: sl<AuthRepository>())
                    ..add(AuthCheck()),
        ),
        BlocProvider(
          create:
              (_) => CatalogBloc(catalogRepository: sl<CatalogRepository>()),
        ),
        BlocProvider(
          create: (_) => CartBloc(cartRepository: sl<CartRepository>()),
        ),
        BlocProvider(
          create:
              (_) => PurchaseBloc(purchaseRepository: sl<PurchaseRepository>()),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Default to false unless authenticated
          final isLoggedIn = state.isAuthenticated;

          final router = AppRouter.generate(isLoggedIn);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
          );
        },
      ),
    );
  }
}
