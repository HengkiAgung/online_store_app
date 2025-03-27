import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:online_stores_app/repositories/auth_repository.dart';
import 'package:online_stores_app/repositories/cart_repository.dart';
import 'package:online_stores_app/repositories/catalog_repository.dart';
import 'package:online_stores_app/repositories/purchase_repository.dart';
import 'package:online_stores_app/services/http_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => HttpService());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(httpService: sl()),
  );

  sl.registerLazySingleton<CatalogRepository>(
    () => CatalogRepository(httpService: sl()),
  );

  sl.registerLazySingleton<CartRepository>(
    () => CartRepository(httpService: sl()),
  );

  sl.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepository(httpService: sl()),
  );
}
