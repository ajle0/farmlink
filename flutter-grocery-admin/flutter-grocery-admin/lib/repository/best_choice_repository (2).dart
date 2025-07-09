import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/db/best_choice_dao.dart';
import 'package:fluttermultigrocery/repository/Common/ps_repository.dart';
import 'package:fluttermultigrocery/viewobject/best_choice.dart';

class BestChoiceRepository extends PsRepository {
  BestChoiceRepository(
      {required PsApiService psApiService,
      required BestChoiceDao bestChoiceDao}) {
    _psApiService = psApiService;
    _bestChoiceDao = bestChoiceDao;
  }

late  PsApiService _psApiService;
late  BestChoiceDao _bestChoiceDao;
  final String _primaryKey = 'id';

  void sinkProductListStream(
      StreamController<PsResource<List<BestChoice>>>
          productCollectionListStream,
      PsResource<List<BestChoice>>? dataList) {
    if (dataList != null) {
      productCollectionListStream.sink.add(dataList);
    }
  }

  void sinkProductStream(
      StreamController<PsResource<BestChoice>>
          productCollectionStream,
      PsResource<BestChoice>? data) {
    if (data != null) {
      productCollectionStream.sink.add(data);
    }
  }

  Future<dynamic> insert(
      BestChoice bestChoice) async {
    return _bestChoiceDao.insert(_primaryKey, bestChoice);
  }

  Future<dynamic> update(
      BestChoice bestChoice) async {
    return _bestChoiceDao.update(bestChoice);
  }

  Future<dynamic> delete(
      BestChoice bestChoice) async {
    return _bestChoiceDao.delete(bestChoice);
  }

  Future<dynamic> getBestChoiceList(
      StreamController<PsResource<List<BestChoice>>>
        productCollectionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {

     sinkProductListStream(productCollectionListStream,
        await _bestChoiceDao.getAll(status: status));

        print(limit);

    if (isConnectedToInternet) {
      final PsResource<List<BestChoice>> resource =
          await _psApiService.getBestChoiceList();

      if (resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _bestChoiceDao.deleteAll();
        }
        await _bestChoiceDao.insertAll(_primaryKey, resource.data!);
        sinkProductListStream(productCollectionListStream,
        await _bestChoiceDao.getAll(status: status));
      } else {
        if (resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _bestChoiceDao.deleteAll();
        }
      }
    }
  }

  Future<dynamic> getNextPageBestChoiceList(
      StreamController<PsResource<List<BestChoice>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
      productCollectionListStream.sink.add(
        await _bestChoiceDao.getAll(status: status));
    if (isConnectedToInternet) {
      final PsResource<List<BestChoice>> resource =
          await _psApiService.getBestChoiceList();

      if (resource.status == PsStatus.SUCCESS) {
        _bestChoiceDao
            .insertAll(_primaryKey, resource.data!)
            .then((dynamic data) async {
            sinkProductListStream(productCollectionListStream,
              await _bestChoiceDao.getAll(status: status));
        });
      } else {
          sinkProductListStream(productCollectionListStream,
              await _bestChoiceDao.getAll());
      }
    }
  }
}
