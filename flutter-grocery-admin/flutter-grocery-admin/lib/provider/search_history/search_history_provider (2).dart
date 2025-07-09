import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/provider/common/ps_provider.dart';
import 'package:fluttermultigrocery/repository/search_history_repository.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/search_history.dart';

class SearchHistoryProvider extends PsProvider {
  SearchHistoryProvider(
      {required SearchHistoryRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    Utils.psPrintProvider(runtimeType, hashCode);

    searchHistoryListStream =
        StreamController<PsResource<List<SearchHistory>>>.broadcast();
    subscription = searchHistoryListStream.stream
        .listen((PsResource<List<SearchHistory>> resource) {
      updateOffset(resource.data!.length);

      _historyList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  SearchHistoryRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<SearchHistory>> _historyList =
      PsResource<List<SearchHistory>>(PsStatus.NOACTION, '', <SearchHistory>[]);

  PsResource<List<SearchHistory>> get historyList => _historyList;
 late StreamSubscription<PsResource<List<SearchHistory>>> subscription;
 late StreamController<PsResource<List<SearchHistory>>> searchHistoryListStream;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    Utils.psPrintProvider(runtimeType, hashCode, true);
    super.dispose();
  }

  Future<dynamic> loadSearchHistoryList() async {
    isLoading = true;
    await _repo!.getAllSearchHistoryList(
        searchHistoryListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> addSearchHistoryList(SearchHistory searchHistory) async {
    isLoading = true;
    await _repo!.addAllSearchHistoryList(
        searchHistoryListStream, PsStatus.PROGRESS_LOADING, searchHistory);
  }

  Future<dynamic> deleteSearchHistory(SearchHistory searchHistory) async {
    isLoading = true;
    await _repo!.deleteSearchHistory(searchHistoryListStream, searchHistory);
  }

  Future<void> resetSearchHistoryList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllSearchHistoryList(
        searchHistoryListStream, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
