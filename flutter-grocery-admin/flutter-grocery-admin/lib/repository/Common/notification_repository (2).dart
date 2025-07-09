import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/repository/Common/ps_repository.dart';
import 'package:fluttermultigrocery/viewobject/api_status.dart';

class NotificationRepository extends PsRepository {
  NotificationRepository({required PsApiService psApiService}) {
    _psApiService = psApiService;
  }

 late PsApiService _psApiService;

  //noti register
  Future<PsResource<ApiStatus>> rawRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> resource =
        await _psApiService.rawRegisterNotiToken(jsonMap);
    if (resource.status == PsStatus.SUCCESS) {
      return resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(resource);
      return completer.future;
    }
  }
  //end region

  //noti unregister
  Future<PsResource<ApiStatus>> rawUnRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> resource =
        await _psApiService.rawUnRegisterNotiToken(jsonMap);
    if (resource.status == PsStatus.SUCCESS) {
      return resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(resource);
      return completer.future;
    }
  }

  //end region
}
