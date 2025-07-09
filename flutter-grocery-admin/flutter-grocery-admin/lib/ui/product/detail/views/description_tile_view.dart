import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_expansion_tile.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/product.dart';

class DescriptionTileView extends StatelessWidget {
  const DescriptionTileView({
    super.key,
    required this.productDetail,
  });

  final Product productDetail;
  @override
  Widget build(BuildContext context) {
    final Widget expansionTileTitleWidget = Text(
        Utils.getString(context, 'description_tile__product_description'),
        style: Theme.of(context).textTheme.titleLarge);
    if (productDetail.description != null) {
      return Container(
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: PsDimens.space16,
                  left: PsDimens.space16,
                  right: PsDimens.space16),
              child: Text(
                productDetail.description ?? '',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 1.3,
                      letterSpacing: 0.5,
                    ),
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
