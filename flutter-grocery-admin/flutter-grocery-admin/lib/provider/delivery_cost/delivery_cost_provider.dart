import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/provider/common/ps_provider.dart';
import 'package:fluttermultigrocery/repository/delivery_cost_repository.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/delivery_cost.dart';


class DeliveryCostProvider extends PsProvider {
  DeliveryCostProvider(
      {required DeliveryCostRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

  

    print('DeliveryCost Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  DeliveryCostRepository? _repo;
  PsValueHolder? psValueHolder;

 late StreamController<PsResource<DeliveryCost>> deliveryCostListStream;

  PsResource<DeliveryCost> _deliveryCost =
      PsResource<DeliveryCost>(PsStatus.NOACTION, '', null);
  PsResource<DeliveryCost> get deliveryCost => _deliveryCost;
  @override
  void dispose() {
    isDispose = true;
    print('Delivery Cost Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postDeliveryCost(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _deliveryCost = await _repo!.postDeliveryCheckingAndCalculating(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _deliveryCost;
  }
}
