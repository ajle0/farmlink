import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_hero.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/product.dart';
import 'package:provider/provider.dart';

class ProductVeticalListItemForHome extends StatelessWidget {
  const ProductVeticalListItemForHome(
      {super.key,
      required this.product,
      this.onTap,
      this.onButtonTap,
      this.coreTagKey});

  final Product? product;
  final Function ?onTap;
  final Function? onButtonTap;
  final String? coreTagKey;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return GestureDetector(
        onTap: onTap as void Function()?,
        child: GridTile(
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: PsDimens.space8, vertical: PsDimens.space8),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius:
                  const BorderRadius.all(Radius.circular(PsDimens.space8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(PsDimens.space8)),
                    ),
                    child: ClipPath(
                      clipper: const ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(PsDimens.space8),
                                  topRight: Radius.circular(PsDimens.space8)))),
                      child: PsNetworkImage(
                        photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                        defaultPhoto: product!.defaultPhoto!,
                        width: PsDimens.space180,
                        height: PsDimens.space160,
                        boxfit: BoxFit.cover,
                        onTap: () {
                          Utils.psPrint(product!.defaultPhoto!.imgParentId!);
                          onTap!();
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: PsDimens.space8,
                      top: PsDimens.space8,
                      right: PsDimens.space8),
                  child: Row(
                    children: <Widget>[
                      PsHero(
                        tag: '$coreTagKey${PsConst.HERO_TAG__UNIT_PRICE}',
                        flightShuttleBuilder: Utils.flightShuttleBuilder,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                              '${product!.currencySymbol}${Utils.getPriceFormat(product!.unitPrice!, valueHolder)}',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: PsColors.mainColor)),
                        ),
                      ),
                      const SizedBox(width: PsDimens.space2),
                      Expanded(
                        child: Text(
                          ' ${Utils.getPriceFormat(product!.productUnitValue!, valueHolder)}'
                          ' ${product!.productUnit}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontSize: PsDimens.space12,
                              ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space2,
                        top: PsDimens.space8,
                        right: PsDimens.space8,
                        bottom: PsDimens.space2),
                    child: product!.isDiscount == PsConst.ONE
                        ? Text(
                            '  ${product!.discountPercent}% ${Utils.getString(
                                    context, 'product_detail__discount_off')}',
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: PsColors.discountColor),
                          )
                        : Text(
                            '',
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: PsColors.discountColor),
                          )),
                Padding(
                  padding: const EdgeInsets.only(
                      left: PsDimens.space8,
                      top: PsDimens.space8,
                      right: PsDimens.space8,
                      bottom: PsDimens.space12),
                  child: PsHero(
                    tag: '$coreTagKey${PsConst.HERO_TAG__TITLE}',
                    child: Text(
                      product!.name!,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                    child: Row(children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space8,
                          right: PsDimens.space8,
                          bottom: PsDimens.space12),
                      child: PsHero(
                        tag: '$coreTagKey${PsConst.HERO_TAG__ORIGINAL_PRICE}',
                        child: Text(
                          product!.shop!.name!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: PsColors.mainColor),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: PsDimens.space4),
                      child: IconButton(
                          iconSize: PsDimens.space32,
                          icon:
                              Icon(Icons.add_circle, color: PsColors.mainColor),
                          onPressed: () {
                            onButtonTap!();
                          })),
                ])),
              ],
            ),
          ),
        ));
  }
}
