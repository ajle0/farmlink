import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/db/blog_dao.dart';
import 'package:fluttermultigrocery/viewobject/blog.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class BlogRepository extends PsRepository {
  BlogRepository(
      {required PsApiService psApiService, required BlogDao blogDao}) {
    _psApiService = psApiService;
    _blogDao = blogDao;
  }

  String primaryKey = 'id';
 late PsApiService _psApiService;
 late BlogDao _blogDao;

  Future<dynamic> insert(Blog blog) async {
    return _blogDao.insert(primaryKey, blog);
  }

  Future<dynamic> update(Blog blog) async {
    return _blogDao.update(blog);
  }

  Future<dynamic> delete(Blog blog) async {
    return _blogDao.delete(blog);
  }

  Future<dynamic> getAllBlogList(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> resource =
          await _psApiService.getBlogList(limit, offset);

      if (resource.status == PsStatus.SUCCESS) {
        await _blogDao.deleteAll();
        await _blogDao.insertAll(primaryKey, resource.data!);
      } else {
        if (resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _blogDao.deleteAll();
        }
      }
      blogListStream.sink.add(await _blogDao.getAll());
    }
  }

  Future<dynamic> getNextPageBlogList(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> resource =
          await _psApiService.getBlogList(limit, offset);

      if (resource.status == PsStatus.SUCCESS) {
        await _blogDao.insertAll(primaryKey, resource.data!);
      }
      blogListStream.sink.add(await _blogDao.getAll());
    }
  }

  Future<dynamic> getAllBlogListByShopId(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      String shopId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('shop_id', shopId));
    blogListStream.sink
        .add(await _blogDao.getAll(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> resource =
          await _psApiService.getBlogListByShopId(shopId, limit, offset);

      if (resource.status == PsStatus.SUCCESS) {
        await _blogDao.deleteWithFinder(finder);
        await _blogDao.insertAll(primaryKey, resource.data!);
      } else {
        if (resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _blogDao.deleteWithFinder(finder);
        }
      }
      blogListStream.sink.add(await _blogDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPageBlogListByShopId(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      String shopId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('shop_id', shopId));
    blogListStream.sink
        .add(await _blogDao.getAll(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> resource =
          await _psApiService.getBlogListByShopId(shopId, limit, offset);

      if (resource.status == PsStatus.SUCCESS) {
        await _blogDao.insertAll(primaryKey, resource.data!);
      }
      blogListStream.sink.add(await _blogDao.getAll(finder: finder));
    }
  }
}
