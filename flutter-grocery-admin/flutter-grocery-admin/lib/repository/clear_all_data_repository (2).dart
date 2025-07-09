import 'dart:async';

import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/db/basket_dao.dart';
import 'package:fluttermultigrocery/db/blog_dao.dart';
import 'package:fluttermultigrocery/db/category_map_dao.dart';
import 'package:fluttermultigrocery/db/cateogry_dao.dart';
import 'package:fluttermultigrocery/db/comment_detail_dao.dart';
import 'package:fluttermultigrocery/db/comment_header_dao.dart';
import 'package:fluttermultigrocery/db/product_collection_header_dao.dart';
import 'package:fluttermultigrocery/db/product_dao.dart';
import 'package:fluttermultigrocery/db/product_map_dao.dart';
import 'package:fluttermultigrocery/db/rating_dao.dart';
import 'package:fluttermultigrocery/db/sub_category_dao.dart';
import 'package:fluttermultigrocery/db/transaction_detail_dao.dart';
import 'package:fluttermultigrocery/db/transaction_header_dao.dart';
import 'package:fluttermultigrocery/repository/Common/ps_repository.dart';
import 'package:fluttermultigrocery/viewobject/product.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Product>>> allListStream) async {
    final ProductDao productDao = ProductDao.instance;
    final CategoryDao categoryDao = CategoryDao();
    final CommentHeaderDao commentHeaderDao = CommentHeaderDao.instance;
    final CommentDetailDao commentDetailDao = CommentDetailDao.instance;
    final BasketDao basketDao = BasketDao.instance;
    final CategoryMapDao categoryMapDao = CategoryMapDao.instance;
    final ProductCollectionDao productCollectionDao =
        ProductCollectionDao.instance;
    final ProductMapDao productMapDao = ProductMapDao.instance;
    final RatingDao ratingDao = RatingDao.instance;
    final SubCategoryDao subCategoryDao = SubCategoryDao();
    final TransactionHeaderDao transactionHeaderDao =
        TransactionHeaderDao.instance;
    final TransactionDetailDao transactionDetailDao =
        TransactionDetailDao.instance;
    final BlogDao blogDao = BlogDao.instance;
    await productDao.deleteAll();
    await blogDao.deleteAll();
    await categoryDao.deleteAll();
    await commentHeaderDao.deleteAll();
    await commentDetailDao.deleteAll();
    await basketDao.deleteAll();
    await categoryMapDao.deleteAll();
    await productCollectionDao.deleteAll();
    await productMapDao.deleteAll();
    await ratingDao.deleteAll();
    await subCategoryDao.deleteAll();
    await transactionHeaderDao.deleteAll();
    await transactionDetailDao.deleteAll();

    allListStream.sink.add(await productDao.getAll(status: PsStatus.SUCCESS));
  }
}
