import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/viewobject/delivery_cost.dart';

import 'Common/ps_repository.dart';

class DeliveryCostRepository extends PsRepository {
  DeliveryCostRepository({
    required PsApiService psApiService,
  }) {
    _psApiService = psApiService;
  }
  String primaryKey = 'id';
 late PsApiService _psApiService;

  Future<PsResource<DeliveryCost>> postDeliveryCheckingAndCalculating(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<DeliveryCost> resource =
        await _psApiService.postDeliveryCheckingAndCalculating(jsonMap);
    if (resource.status == PsStatus.SUCCESS) {
      return resource;
    } else {
      final Completer<PsResource<DeliveryCost>> completer =
          Completer<PsResource<DeliveryCost>>();
      completer.complete(resource);
      return completer.future;
    }
  }
}
