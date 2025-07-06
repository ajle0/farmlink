import 'dart:async';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/db/basket_dao.dart';
import 'package:fluttermultigrocery/db/favourite_product_dao.dart';
import 'package:fluttermultigrocery/db/history_dao.dart';
import 'package:fluttermultigrocery/db/search_history_dao.dart';
import 'package:fluttermultigrocery/db/transaction_detail_dao.dart';
import 'package:fluttermultigrocery/db/transaction_header_dao.dart';
import 'package:fluttermultigrocery/db/user_login_dao.dart';
import 'package:fluttermultigrocery/repository/Common/ps_repository.dart';

import 'package:fluttermultigrocery/viewobject/user_login.dart';

class DeleteTaskRepository extends PsRepository {
  Future<dynamic> deleteTask(
      StreamController<PsResource<List<UserLogin>>> allListStream) async {
    final FavouriteProductDao favProductDao = FavouriteProductDao.instance;
    final SearchHistoryDao searchHistoryDao = SearchHistoryDao.instance;
    final UserLoginDao userLoginDao = UserLoginDao.instance;
    final TransactionHeaderDao transactionHeaderDao =
        TransactionHeaderDao.instance;
    final TransactionDetailDao transactionDetailDao =
        TransactionDetailDao.instance;
    final BasketDao basketDao = BasketDao.instance;
    final HistoryDao historyDao = HistoryDao.instance;
    await favProductDao.deleteAll();
    await userLoginDao.deleteAll();
    await transactionHeaderDao.deleteAll();
    await transactionDetailDao.deleteAll();
    await basketDao.deleteAll();
    await historyDao.deleteAll();
    await searchHistoryDao.deleteAll();


    allListStream.sink
        .add(await userLoginDao.getAll(status: PsStatus.SUCCESS));
  }
}
