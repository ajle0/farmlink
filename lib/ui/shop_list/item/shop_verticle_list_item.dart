import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/ui/common/smooth_star_rating_widget.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/shop.dart';
import 'package:map_launcher/map_launcher.dart';

class ShopVerticleListItem extends StatelessWidget {
  const ShopVerticleListItem(
      {super.key,
      required this.shop,
      this.onTap,
      this.animationController,
      this.animation});

  final Shop shop;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
            onTap: onTap as void Function()?,
            child: Card(
              elevation: 0.0,
              color: PsColors.transparent,
              child: Container(
                  margin: const EdgeInsets.all(PsDimens.space8),
                  child: ShopVerticleListItemWidget(shop: shop)),
            )),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child,
              ));
        });
  }
}

class ShopVerticleListItemWidget extends StatelessWidget {
  const ShopVerticleListItemWidget({
    super.key,
    required this.shop,
  });

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(PsDimens.space4),
          child: PsNetworkImage(
            height: PsDimens.space200,
            width: PsDimens.space200,
            photoKey: '',
            defaultPhoto: shop.defaultPhoto!,
            boxfit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space12),
          child: Text(
            shop.name!,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            child: Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              left: PsDimens.space12,
              right: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                '\$',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: shop.priceLevel == PsConst.PRICE_LOW ||
                            shop.priceLevel == PsConst.PRICE_MEDIUM ||
                            shop.priceLevel == PsConst.PRICE_HIGH
                        ? PsColors.mainColor
                        : PsColors.grey),
                maxLines: 2,
              ),
              Text(
                '\$',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: shop.priceLevel == PsConst.PRICE_MEDIUM ||
                            shop.priceLevel == PsConst.PRICE_HIGH
                        ? PsColors.mainColor
                        : PsColors.grey),
                maxLines: 2,
              ),
              Text(
                '\$',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: shop.priceLevel == PsConst.PRICE_HIGH
                        ? PsColors.mainColor
                        : PsColors.grey),
                maxLines: 2,
              ),
              const SizedBox(width: PsDimens.space8),
              if (shop.shopSchedules != null)
                Expanded(
                  child: getOpenAndCloseTime(context),
                ),
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              bottom: PsDimens.space12,
              left: PsDimens.space8,
              right: PsDimens.space8),
          child: Text(
            shop.description!,
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              bottom: PsDimens.space8,
              right: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SmoothStarRating(
                      key: Key(shop.ratingDetail!.totalRatingValue!),
                      rating: double.parse(shop.ratingDetail!.totalRatingValue!),
                      allowHalfRating: false,
                      onRated: (double? v) {
                        // onTap();
                      },
                      starCount: 5,
                      size: 20.0,
                      color: PsColors.ratingColor,
                      borderColor: PsColors.grey.withAlpha(100),
                      spacing: 0.0),
                  Text('  ( ${shop.ratingDetail!.totalRatingCount} )',
                      // '${Utils.getString(context, 'feature_slider__rating')}',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              Container(
                          child: GestureDetector(
                              child: Icon(FontAwesome5.directions,
                                  size: 32, color: PsColors.mainColor),
                              onTap: () async {
                                print('opening map');

                                if (Platform.isIOS) {
                                  await MapLauncher.showMarker(
                                    mapType: MapType.apple,
                                    coords: Coords(double.parse(shop.lat!),
                                        double.parse(shop.lng!)),
                                    title: 'Shop on Map',
                                  );
                                } else {
                                  await MapLauncher.showMarker(
                                    mapType: MapType.google,
                                    coords: Coords(double.parse(shop.lat!),
                                        double.parse(shop.lng!)),
                                    title: 'Shop on Map',
                                  );
                                }
                              }),
                        ),
            ],
          ),
        ),
      ],
    );
  }

  dynamic getOpenAndCloseTime(BuildContext context) {
    final String dateAndTime = DateFormat.yMMMMEEEEd('en_US').format(DateTime.now());
    final String  days = dateAndTime.split(',').first;
    if (days == 'Monday') {
      if (shop.shopSchedules!.mondayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.mondayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.mondayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Tuesday') {
      if (shop.shopSchedules!.tuesdayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.tuesdayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.tuesdayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Wednesday') {
      if (shop.shopSchedules!.wednesdayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.wednesdayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.wednesdayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Thursday') {
      if (shop.shopSchedules!.thursdayCloseHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.thursdayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.thursdayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Friday') {
      if (shop.shopSchedules!.fridayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.fridayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.fridayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Saturday') {
      if (shop.shopSchedules!.saturdayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.saturdayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.saturdayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Sunday') {
      if (shop.shopSchedules!.sundayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.sundayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.sundayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    }
  }
}
