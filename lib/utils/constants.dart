class ApiRoutes {
  static const baseUrl = 'http://172.27.4.115:8000/api';

  static const register = '/register';
  static const login = '/login';
  static const getUserProfile = '/users/me';

  static const getCatalog = '/catalog';
  static String getDetailCatalog(String id) => '/catalog/$id';

  static const getCart = '/cart';
  static const addToCart = '/cart/add';
  static const updateQuantity = '/cart/update';

  static const getHistories = '/purchase/history';
  static String getHistoryById(String id) => '/purchase/history/$id';

  static const checkout = '/purchase/checkout';
}
