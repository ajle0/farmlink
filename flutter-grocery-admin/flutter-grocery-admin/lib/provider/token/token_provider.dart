import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/provider/common/ps_provider.dart';
import 'package:fluttermultigrocery/repository/token_repository.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/api_status.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';

class TokenProvider extends PsProvider {
  TokenProvider({
    required TokenRepository repo, 
    required this.psValueHolder,
    int limit = 0})
      : super(repo, limit) {
    _repo = repo;

  

    print('Token Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  TokenRepository? _repo;
  PsValueHolder? psValueHolder;
  @override
  void dispose() {
    isDispose = true;
    print('Token Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadToken() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final PsResource<ApiStatus> resource =
        await _repo!.getToken(isConnectedToInternet, PsStatus.SUCCESS);
    return resource;
  }
}
