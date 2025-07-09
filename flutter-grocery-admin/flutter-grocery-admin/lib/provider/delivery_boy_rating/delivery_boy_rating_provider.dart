import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/provider/common/ps_provider.dart';
import 'package:fluttermultigrocery/repository/delivery_boy_rating_repository.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/delivery_boy_rating.dart';

class DeliveryBoyRatingProvider extends PsProvider {
  DeliveryBoyRatingProvider({
    required DeliveryBoyRatingRepository repo,
    required this.psValueHolder, 
    int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    
  

    print('Delivery Boy DeliveryBoyRating Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    ratingListStream = StreamController<PsResource<List<DeliveryBoyRating>>>.broadcast();
    subscription =
        ratingListStream.stream.listen((PsResource<List<DeliveryBoyRating>> resource) {
      updateOffset(resource.data!.length);

      _ratingList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  DeliveryBoyRatingRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<DeliveryBoyRating> _rating = PsResource<DeliveryBoyRating>(PsStatus.NOACTION, '', null);
  PsResource<DeliveryBoyRating> get rating => _rating;

  PsResource<List<DeliveryBoyRating>> _ratingList =
      PsResource<List<DeliveryBoyRating>>(PsStatus.NOACTION, '', <DeliveryBoyRating>[]);

  PsResource<List<DeliveryBoyRating>> get ratingList => _ratingList;
 late StreamSubscription<PsResource<List<DeliveryBoyRating>>> subscription;
 late StreamController<PsResource<List<DeliveryBoyRating>>> ratingListStream;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('DeliveryBoyRating Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postDeliveryBoyRating(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _rating = await _repo!.postDeliveryBoyRating(
        ratingListStream, jsonMap, isConnectedToInternet);

    return _rating;
  }
}
