import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/viewobject/search_history.dart';

class SearchHistoryListItem extends StatelessWidget {
  const SearchHistoryListItem({
    super.key,
    required this.searchHistory,
    this.onTap,
    this.onDeleteTap
  });

  final SearchHistory searchHistory;
  final Function? onTap;
  final Function? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
            width: PsDimens.space140,
            padding: const EdgeInsets.only(
              left: PsDimens.space4,
              right: PsDimens.space4,
              top: PsDimens.space8),
            child: MaterialButton(
                color: PsColors.baseColor,
                height: 28,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: PsColors.mainDividerColor),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(15.0))),
                    onPressed: onTap as void Function()?,
                  child: Align(
                   alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              searchHistory.searchTeam!,
                              textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: PsColors.iconColor),
                              ),
                            ),
                            InkWell(
                              onTap: onDeleteTap as void Function()?,
                              child: Icon(
                                  Icons.clear,
                                  color: PsColors.iconColor,
                                  size: 16, 
                                  ), 
                            ),
                          ]),
                       )),
              ),
    );
  }
}
