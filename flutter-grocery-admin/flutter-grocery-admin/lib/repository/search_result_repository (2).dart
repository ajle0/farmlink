import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/db/search_result_dao.dart';
import 'package:fluttermultigrocery/repository/Common/ps_repository.dart';
import 'package:fluttermultigrocery/viewobject/search_result.dart';
import 'package:sembast/sembast.dart';

import '../api/common/ps_resource.dart';

class SearchResultRepository extends PsRepository {
  SearchResultRepository({
    required PsApiService apiService,
    required SearchResultDao searchResultDao,
  }) {
    _apiService = apiService;
    _searchResultDao = searchResultDao;
  }
late  PsApiService _apiService;
 late SearchResultDao _searchResultDao;
  String primaryKey = 'id';

  Future<dynamic> getSearchResult(
    StreamController<PsResource<SearchResult>> searchResultStream,
    bool isConnectedToInternet,
    int offset,
    PsStatus status,
    Map<String, dynamic> json,
  ) async {
    sinkSearchResultStream(
        searchResultStream,
        await _searchResultDao.getOne(
          finder: Finder(
            filter: Filter.equals(primaryKey, json['searchterm']),
          ),
          status: status,
        ));

    if (isConnectedToInternet) {
      final PsResource<SearchResult> resource =
          await _apiService.getSearchResult(json, offset);

      final SearchResult searchResult = SearchResult(
        id: json['searchterm'],
        categories: resource.data!.categories,
        subCategories: resource.data!.subCategories,
        products: resource.data!.products,
        shops: resource.data!.shops,
      );
      await _searchResultDao.insert(primaryKey, searchResult);
      if (resource.status == PsStatus.SUCCESS) {
        sinkSearchResultStream(searchResultStream, resource);
      }
    }
  }
}

void sinkSearchResultStream(
    StreamController<PsResource<SearchResult>>? searchResultStream,
    PsResource<SearchResult>? data) {
  if (searchResultStream != null && data != null) {
    searchResultStream.sink.add(data);
  }
}
