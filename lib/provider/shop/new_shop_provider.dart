import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/provider/common/ps_provider.dart';
import 'package:fluttermultigrocery/repository/shop_repository.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/api_status.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/shop_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/shop.dart';

class NewShopProvider extends PsProvider {
  NewShopProvider(
      {required ShopRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('NewShopProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shopListStream = StreamController<PsResource<List<Shop>>>.broadcast();

    subscription =
        shopListStream.stream.listen((PsResource<List<Shop>> resource) {
      updateOffset(resource.data!.length);

      _shopList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ShopRepository? _repo;
  PsValueHolder? psValueHolder;
  PsResource<List<Shop>> _shopList =
      PsResource<List<Shop>>(PsStatus.NOACTION, '', <Shop>[]);

  PsResource<List<Shop>> get shopList => _shopList;
late  StreamSubscription<PsResource<List<Shop>>> subscription;
late  StreamController<PsResource<List<Shop>>> shopListStream;
  ShopParameterHolder shopNearYouParameterHolder =
      ShopParameterHolder().getShopNearYouParameterHolder();

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Shop Near You Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShopList(ShopParameterHolder shopParameterHolder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getShopList(shopListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, shopParameterHolder);
  }

  Future<dynamic> nextShopList(ShopParameterHolder shopParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getShopList(shopListStream, isConnectedToInternet, limit,
          offset, PsStatus.PROGRESS_LOADING, shopParameterHolder);
    }
  }

  Future<dynamic> resetShopList(ShopParameterHolder shopParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    updateOffset(0);
    await _repo!.getShopList(shopListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, shopParameterHolder);
  }

  Future<dynamic> postTouchCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postTouchCount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
