import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/repository/Common/ps_repository.dart';
import 'package:fluttermultigrocery/viewobject/ps_app_info.dart';

class AppInfoRepository extends PsRepository {
  AppInfoRepository({
    required PsApiService psApiService,
  }) {
    _psApiService = psApiService;
  }
 late PsApiService _psApiService;

  Future<PsResource<PSAppInfo>> postDeleteHistory(Map<dynamic, dynamic> jsonMap,
      {bool isLoadFromServer = true}) async {
    final PsResource<PSAppInfo> resource =
        await _psApiService.postPsAppInfo(jsonMap);
    if (resource.status == PsStatus.SUCCESS) {
      if (resource.data!.deleteObject!.isNotEmpty) {}
      return resource;
    } else {
      final Completer<PsResource<PSAppInfo>> completer =
          Completer<PsResource<PSAppInfo>>();
      completer.complete(resource);
      return completer.future;
    }
  }
}
