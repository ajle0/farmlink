import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/db/delivery_boy_rating_dao.dart';
import 'package:fluttermultigrocery/viewobject/delivery_boy_rating.dart';

import 'Common/ps_repository.dart';

class DeliveryBoyRatingRepository extends PsRepository {
  DeliveryBoyRatingRepository(
      {required PsApiService psApiService, required DeliveryBoyRatingDao ratingDao}) {
    _psApiService = psApiService;
    _ratingDao = ratingDao;
  }

  String primaryKey = 'id';
 late PsApiService _psApiService;
late  DeliveryBoyRatingDao _ratingDao;

  Future<dynamic> insert(DeliveryBoyRating rating) async {
    return _ratingDao.insert(primaryKey, rating);
  }

  Future<dynamic> update(DeliveryBoyRating rating) async {
    return _ratingDao.update(rating);
  }

  Future<dynamic> delete(DeliveryBoyRating rating) async {
    return _ratingDao.delete(rating);
  }

  Future<PsResource<DeliveryBoyRating>> postDeliveryBoyRating(
      StreamController<PsResource<List<DeliveryBoyRating>>> ratingListStream,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      {bool isLoadFromServer = true}) async {
    final PsResource<DeliveryBoyRating> resource =
        await _psApiService.postDeliveryBoyRating(jsonMap);
    if (resource.status == PsStatus.SUCCESS) {
      ratingListStream.sink
          .add(await _ratingDao.getAll(status: PsStatus.SUCCESS));
      return resource;
    } else {
      final Completer<PsResource<DeliveryBoyRating>> completer =
          Completer<PsResource<DeliveryBoyRating>>();
      completer.complete(resource);
      ratingListStream.sink
          .add(await _ratingDao.getAll(status: PsStatus.SUCCESS));
      return completer.future;
    }
  }
}
