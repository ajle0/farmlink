import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/provider/common/ps_provider.dart';
import 'package:fluttermultigrocery/repository/best_choice_repository.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/best_choice.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';

class BestChoiceProvider extends PsProvider {
  BestChoiceProvider(
      {required BestChoiceRepository? repo, 
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    

    print('ProductCollection Provider: $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productCollectionListStream =
        StreamController<PsResource<List<BestChoice>>>.broadcast();
    subscription =
        productCollectionListStream.stream.listen((dynamic resource) {

      updateOffset(resource.data.length);

      _productCollectionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    productCollectionStream =
        StreamController<PsResource<BestChoice>>.broadcast();
    subscriptionById =
        productCollectionStream.stream.listen((dynamic resource) {
      _productCollection = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  BestChoiceRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<BestChoice>> _productCollectionList =
      PsResource<List<BestChoice>>(
          PsStatus.NOACTION, '', <BestChoice>[]);

  PsResource<BestChoice> _productCollection =
      PsResource<BestChoice>(PsStatus.NOACTION, '', null);

  PsResource<List<BestChoice>> get productCollectionList =>
      _productCollectionList;

  PsResource<BestChoice> get productCollection =>
      _productCollection;

 late StreamSubscription<PsResource<List<BestChoice>>> subscription;
 late StreamController<PsResource<List<BestChoice>>>
      productCollectionListStream;

 late StreamSubscription<PsResource<BestChoice>> subscriptionById;
 late StreamController<PsResource<BestChoice>> productCollectionStream;
  @override
  void dispose() {
    subscription.cancel();
    subscriptionById.cancel();
    isDispose = true;
    print('Product Collection Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBestChoiceList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getBestChoiceList(productCollectionListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextBestChoiceList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageBestChoiceList(productCollectionListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetBestChoiceList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getBestChoiceList(productCollectionListStream,
        isConnectedToInternet, limit , offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
  
}
