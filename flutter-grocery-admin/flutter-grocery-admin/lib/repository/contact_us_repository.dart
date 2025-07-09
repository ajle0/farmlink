import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/viewobject/api_status.dart';

import 'Common/ps_repository.dart';

class ContactUsRepository extends PsRepository {
  ContactUsRepository({
    required PsApiService psApiService,
  }) {
    _psApiService = psApiService;
  }
  String primaryKey = 'id';
 late PsApiService _psApiService;

  Future<PsResource<ApiStatus>> postContactUs(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> resource =
        await _psApiService.postContactUs(jsonMap);
    if (resource.status == PsStatus.SUCCESS) {
      return resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(resource);
      return completer.future;
    }
  }
}
