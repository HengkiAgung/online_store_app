import 'package:online_stores_app/models/history_purchase_model.dart';
import 'package:online_stores_app/services/http_service.dart';
import 'package:online_stores_app/utils/constants.dart';

class PurchaseRepository {
  final HttpService httpService;

  PurchaseRepository({required this.httpService});

  Future<List<HistoryPurchaseModel>> getHistories({int page = 1}) async {
    final response = await httpService.get(
      ApiRoutes.getHistories,
      parameters: {'page': page.toString()},
    );

    print(response['data']);

    final List<dynamic> catalogJson = response['data'];

    return catalogJson
        .map((json) => HistoryPurchaseModel.fromJson(json))
        .toList();
  }

  Future<HistoryPurchaseModel> getHistoryById(String historyId) async {
    final response = await httpService.get(ApiRoutes.getHistoryById(historyId));

    return HistoryPurchaseModel.fromJson(response['data']);
  }
}
