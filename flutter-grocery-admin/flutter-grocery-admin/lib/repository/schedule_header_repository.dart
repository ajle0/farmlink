import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/db/schedule_header_dao.dart';
import 'package:fluttermultigrocery/repository/Common/ps_repository.dart';
import 'package:fluttermultigrocery/viewobject/api_status.dart';
import 'package:fluttermultigrocery/viewobject/schedule_header.dart';

import '../api/common/ps_resource.dart';
import '../constant/ps_constants.dart';

class ScheduleHeaderRepository extends PsRepository {
  ScheduleHeaderRepository({
    required PsApiService apiService,
    required ScheduleHeaderDao scheduleHeaderDao,
  }) {
    _psApiService = apiService;
    _scheduleHeaderDao = scheduleHeaderDao;
  }

 late PsApiService _psApiService;
 late ScheduleHeaderDao _scheduleHeaderDao;
  final String _primaryKey = 'id';

  Future<dynamic> postScheduleSubmit(
      StreamController<PsResource<List<ScheduleHeader>>> scheduleListStream,
      Map<String, dynamic> jsonMap,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<List<ScheduleHeader>> resource =
        await _psApiService.postScheduleSubmit(jsonMap);
    if (resource.status == PsStatus.SUCCESS) {
      return resource;
    } else {
      final Completer<PsResource<List<ScheduleHeader>>> completer =
          Completer<PsResource<List<ScheduleHeader>>>();
      completer.complete(resource);
      return completer.future;
    }
  }

  Future<PsResource<List<ScheduleHeader>>> updateScheduleOrderStatus(
      Map<String, dynamic> json, bool isConnectedToInternet) async {
    final PsResource<List<ScheduleHeader>> resource =
        await _psApiService.updateScheduleOrder(json);
    if (resource.status == PsStatus.SUCCESS) {
      return resource;
    } else {
      final Completer<PsResource<List<ScheduleHeader>>> completer =
          Completer<PsResource<List<ScheduleHeader>>>();
      completer.complete(resource);
      return completer.future;
    }
  }

  Future<dynamic> getAllScheduleHeaderList(
      StreamController<PsResource<List<ScheduleHeader>>>
          scheduleHeaderListStream,
      String userId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status) async {
    scheduleHeaderListStream.sink
        .add(await _scheduleHeaderDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ScheduleHeader>> resource = await _psApiService
          .getAllScheduleHeaderByUserId(userId, limit, offset);
      if (resource.status == PsStatus.SUCCESS) {
        await _scheduleHeaderDao.deleteAll();
        await _scheduleHeaderDao.insertAll(_primaryKey, resource.data!);
      } else {
        if (resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _scheduleHeaderDao.deleteAll();
        }
      }
    }
    scheduleHeaderListStream.sink
        .add(await _scheduleHeaderDao.getAll(status: PsStatus.SUCCESS));
  }

  Future<PsResource<ApiStatus>> deleteScheduleOrder(
    Map<String, dynamic> json,
  ) async {
    final PsResource<ApiStatus> resource =
        await _psApiService.deleteSchedule(json);

    if (resource.status == PsStatus.SUCCESS) {
      return resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postResendCode(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> resource =
        await _psApiService.postResendCode(jsonMap);
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
