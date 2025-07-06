import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/product_collection_header.dart';

class DashboardCollectionHeaderListItem extends StatelessWidget {
  const DashboardCollectionHeaderListItem({
    super.key,
    required this.productCollectionHeader,
    required this.onTap,
  });

  final ProductCollectionHeader productCollectionHeader;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(PsDimens.space8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(PsDimens.space4),
            child: PsNetworkImage(
              photoKey: '',
              defaultPhoto: productCollectionHeader.defaultPhoto!,
              width: MediaQuery.of(context).size.width,
              height: PsDimens.space160,
              boxfit: BoxFit.cover,
              onTap: () {
                Utils.psPrint(productCollectionHeader.defaultPhoto!.imgParentId!);
                onTap!();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(productCollectionHeader.name!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: PsDimens.space16)),
          )
        ],
      ),
    );
  }
}
