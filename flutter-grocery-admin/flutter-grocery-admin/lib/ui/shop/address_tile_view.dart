import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_expansion_tile.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/shop_info.dart';

class AddressTileView extends StatelessWidget {
  const AddressTileView({
    super.key,
    required this.shopInfo,
  });

  final ShopInfo shopInfo;
  @override
  Widget build(BuildContext context) {
    final Widget expansionTileTitleWidget = Text(
        Utils.getString(context, 'shop_info__source_address'),
        style: Theme.of(context).textTheme.titleLarge);
    if ( shopInfo.description != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Column(
                children: <Widget>[
                  _AddressWidget(title: shopInfo.address1!),
                  _AddressWidget(title: shopInfo.address2!),
                  _AddressWidget(title: shopInfo.address3!),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space12),
      child: title != ''
          ? Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          : Text(
              '-',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
    );
  }
}
