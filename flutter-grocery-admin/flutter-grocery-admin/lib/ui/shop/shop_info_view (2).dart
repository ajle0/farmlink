import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/rating/shop_rating_provider.dart';
import 'package:fluttermultigrocery/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultigrocery/ui/common/ps_button_widget.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/ui/common/smooth_star_rating_widget.dart';
import 'package:fluttermultigrocery/ui/shop/address_tile_view.dart';
import 'package:fluttermultigrocery/ui/shop/contact_us_tile_view.dart';
import 'package:fluttermultigrocery/ui/shop/customer_review_list_item.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/shop_info_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/shop_info.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopInfoView extends StatefulWidget {
  const ShopInfoView(
      {super.key,
      required this.shopId,
      required this.shopInfoProvider,
      required this.shopRatingProvider,
      this.animationController,
      this.animation});

  final String shopId;
  final ShopInfoProvider shopInfoProvider;
  final ShopRatingProvider shopRatingProvider;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  _ShopInfoViewState createState() => _ShopInfoViewState();
}

class _ShopInfoViewState extends State<ShopInfoView> {
  @override
  Widget build(BuildContext context) {
    widget.animationController!.forward();
    return SliverToBoxAdapter(
        child: AnimatedBuilder(
            animation: widget.animationController!,
            child: Column(
              children: <Widget>[
                _ShopInfoViewWidget(
                    shopId: widget.shopId,
                    shopRatingProvider: widget.shopRatingProvider,
                    shopInfoProvider: widget.shopInfoProvider),
                _ShopBranchWidget(
                    shopInfo: widget.shopInfoProvider.shopInfo.data!,
                    shopId: widget.shopId),
                _CustomerReviewListViewWidget(
                  shopId: widget.shopId,
                  shopInfoProvider: widget.shopInfoProvider,
                  shopRatingProvider: widget.shopRatingProvider,
                )
              ],
            ),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation!,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 30 * (1.0 - widget.animation!.value), 0.0),
                    child: child,
                    // } else {
                    //   return Container();
                    // }
                    // })
                  ));
            }));
  }
}

class _ShopInfoViewWidget extends StatefulWidget {
  const _ShopInfoViewWidget({
    required this.shopId,
    required this.shopRatingProvider,
    required this.shopInfoProvider,
  });

  final String shopId;
  final ShopRatingProvider shopRatingProvider;
  final ShopInfoProvider shopInfoProvider;

  @override
  __ShopInfoViewWidgetState createState() => __ShopInfoViewWidgetState();
}

class __ShopInfoViewWidgetState extends State<_ShopInfoViewWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  bool isShowAdmob = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && isShowAdmob) {
        setState(() {});
      }
    });
  }

  PsValueHolder? psValueHolder;
  LatLng? _latlng;
  final double zoom = 10;
  final MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    _latlng = LatLng(double.parse(widget.shopInfoProvider.shopInfo.data!.lat!),
        double.parse(widget.shopInfoProvider.shopInfo.data!.lng!));

    if (psValueHolder!.isShowAdmob != null &&
        psValueHolder!.isShowAdmob == PsConst.ONE) {
        isShowAdmob = true;
    } else {
        isShowAdmob = false;
    }
    if (!isConnectedToInternet && isShowAdmob) {
      print('loading ads....');
      checkConnection();
    }
    return Container(
      color: PsColors.baseColor,
      child: Column(
        children: <Widget>[
          _HeaderBoxWidget(
              shopRatingProvider: widget.shopRatingProvider,
              shopInfo: widget.shopInfoProvider.shopInfo.data!,
              shopInfoProvider: widget.shopInfoProvider),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: SizedBox(
              height: 250,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: _latlng!, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                  initialZoom: zoom, //10.0,
                  // onTap: (LatLng latLngr) {
                  //   FocusScope.of(context).requestFocus(FocusNode());
                  // }
                ),
                children: <Widget>[
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: <Marker>[
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _latlng!,
                        child: Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.location_on,
                              color: PsColors.mainColor,
                            ),
                            iconSize: 45,
                            onPressed: () {},
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          AddressTileView(
            shopInfo: widget.shopInfoProvider.shopInfo.data!,
          ),
          ContactUsTileView(
            shopInfo: widget.shopInfoProvider.shopInfo.data!,
          ),
        ],
      ),
    );
  }
}

class _ShopBranchWidget extends StatelessWidget {
  const _ShopBranchWidget({
    required this.shopInfo,
    required this.shopId,
  });

  final ShopInfo shopInfo;
  final String shopId;
  @override
  Widget build(BuildContext context) {
    if (shopInfo.branch!.isNotEmpty && shopInfo.branch![0].id != '') {
      // final ShopInfoProvider shopInfoProvider =
      //     Provider.of<ShopInfoProvider>(context, listen: false);
      return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space8,
            bottom: PsDimens.space8),
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(Utils.getString(context, 'shop_info__branch'),
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                ),
                PSButtonWidget(
                    titleText: Utils.getString(context, 'shop_branch_view_all'),
                    colorData: PsColors.mainColor,
                    textColor: PsColors.white,
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RoutePaths.shopbranchContainer,
                          arguments: ShopInfoDataIntentHolder(
                              shopId: shopId, shopInfo: shopInfo));
                    }),
                // SizedBox(
                //   width: double.infinity,
                //   child: RaisedButton(
                //       child: Text(
                //           Utils.getString(context, 'shop_branch_view_all'),
                //           style: Theme.of(context)
                //               .textTheme
                //               .subtitle1
                //               .copyWith(color: PsColors.mainColor)),
                //       color: PsColors.backgroundColor,
                //       onPressed: () {

                //       }),
                // ),
                const SizedBox(
                  height: PsDimens.space12,
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget({
    required this.shopInfo,
    required this.shopInfoProvider,
    required this.shopRatingProvider,
  });

  final ShopInfoProvider shopInfoProvider;
  final ShopInfo shopInfo;
  final ShopRatingProvider shopRatingProvider;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (widget.shopInfo != null) {
      return Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.shopInfo.name!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: PsDimens.space8),
                    Row(
                      children: <Widget>[
                        Text(
                          '\$',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_LOW ||
                                      widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_MEDIUM ||
                                      widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_HIGH
                                  ? PsColors.priceLevelColor
                                  : PsColors.grey),
                          maxLines: 2,
                        ),
                        Text(
                          '\$',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_MEDIUM ||
                                      widget.shopInfo.priceLevel ==
                                          PsConst.PRICE_HIGH
                                  ? PsColors.priceLevelColor
                                  : PsColors.grey),
                          maxLines: 2,
                        ),
                        Text(
                          '\$',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: widget.shopInfo.priceLevel ==
                                      PsConst.PRICE_HIGH
                                  ? PsColors.priceLevelColor
                                  : PsColors.grey),
                          maxLines: 2,
                        ),
                        const SizedBox(width: PsDimens.space8),
                        Text(
                          widget.shopInfo.highlightedInfo!,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: PsDimens.space12,
                    ),
                    Divider(
                      height: PsDimens.space1,
                      color: PsColors.mainColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: PsDimens.space16, bottom: PsDimens.space4),
                      child: _HeaderRatingWidget(
                        shopInfo: widget.shopInfo,
                        shopRatingProvider: widget.shopRatingProvider,
                        shopInfoProvider: widget.shopInfoProvider,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _HeaderRatingWidget extends StatefulWidget {
  const _HeaderRatingWidget(
      {required this.shopInfo,
      required this.shopInfoProvider,
      required this.shopRatingProvider});

  final ShopInfo shopInfo;
  final ShopInfoProvider shopInfoProvider;
  final ShopRatingProvider shopRatingProvider;

  @override
  __HeaderRatingWidgetState createState() => __HeaderRatingWidgetState();
}

class __HeaderRatingWidgetState extends State<_HeaderRatingWidget> {
  @override
  Widget build(BuildContext context) {
    dynamic result;
    // ignore: unnecessary_null_comparison
    if (widget.shopInfo != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () async {
              result = await Navigator.pushNamed(
                  context, RoutePaths.shopRatingList,
                  arguments: widget.shopInfo.id);

              if (result != null && result) {
                widget.shopRatingProvider
                    .refreshShopRatingList(widget.shopInfo.id!);

                await widget.shopInfoProvider.loadShopInfo(widget.shopInfo.id!);
              }
            },
            child: SmoothStarRating(
                key: Key(widget.shopInfo.ratingDetail!.totalRatingValue!),
                rating:
                    double.parse(widget.shopInfo.ratingDetail!.totalRatingValue!),
                allowHalfRating: false,
                starCount: 5,
                isReadOnly: true,
                size: PsDimens.space16,
                color: PsColors.ratingColor,
                borderColor: PsColors.grey.withAlpha(100),
                onRated: (double? v) async {},
                spacing: 0.0),
          ),
          const SizedBox(
            height: PsDimens.space10,
          ),
          GestureDetector(
              onTap: () async {
                result = await Navigator.pushNamed(
                    context, RoutePaths.shopRatingList,
                    arguments: widget.shopInfo.id);

                if (result != null && result) {
                  widget.shopRatingProvider
                      .refreshShopRatingList(widget.shopInfo.id!);
                  widget.shopInfoProvider.loadShopInfo(widget.shopInfo.id!);
                }
              },
              child: (widget.shopInfo.overallRating != '0')
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.shopInfo.ratingDetail!.totalRatingValue ?? '',
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(),
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(
                          '${Utils.getString(context, 'product_detail__out_of_five_stars')}(${widget.shopInfo.ratingDetail!.totalRatingCount!} ${Utils.getString(context, 'product_detail__reviews')})',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(),
                        ),
                      ],
                    )
                  : Text(
                      Utils.getString(context, 'product_detail__no_rating'))),
          const SizedBox(
            height: PsDimens.space16,
          ),
          if (widget.shopInfo.shopSchedules != null)
            getOpenTime()
          else
            Container(),
          if (widget.shopInfo.shopSchedules != null)
            Column(
              children: <Widget>[
                getCloseTime(),
                const SizedBox(
                  height: PsDimens.space16,
                ),
              ],
            )
          else
            Container(),
          Text(
            widget.shopInfo.description!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  dynamic getOpenTime () {
    final String dateAndTime = DateFormat.yMMMMEEEEd('en_US').format(DateTime.now());
    final String days = dateAndTime.split(',').first;
    if (days == 'Monday') {
      if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.mondayOpenHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__opening_hour') +
                  widget.shopInfo.shopSchedules!.mondayOpenHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
            );
        }
    } else if (days == 'Tuesday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.tuesdayOpenHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__opening_hour') +
                  widget.shopInfo.shopSchedules!.tuesdayOpenHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
          );
        }
    } else if (days == 'Wednesday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.wednesdayOpenHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__opening_hour') +
                  widget.shopInfo.shopSchedules!.wednesdayOpenHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    } else if (days == 'Thursday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.thursdayCloseHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__opening_hour') +
                  widget.shopInfo.shopSchedules!.thursdayCloseHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    } else if (days == 'Friday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.fridayOpenHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__opening_hour') +
                  widget.shopInfo.shopSchedules!.fridayOpenHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    } else if (days == 'Saturday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.saturdayOpenHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__opening_hour') +
                  widget.shopInfo.shopSchedules!.saturdayOpenHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    } else if (days == 'Sunday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.sundayOpenHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__opening_hour') +
                  widget.shopInfo.shopSchedules!.sundayOpenHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    }
  }

  dynamic getCloseTime () {
    final String dateAndTime = DateFormat.yMMMMEEEEd('en_US').format(DateTime.now());
    final String days = dateAndTime.split(',').first;
    if (days == 'Monday') {
      if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.mondayCloseHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__closing_hour') +
                  widget.shopInfo.shopSchedules!.mondayCloseHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
            );
        }
    } else if (days == 'Tuesday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.tuesdayCloseHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__closing_hour') +
                  widget.shopInfo.shopSchedules!.tuesdayCloseHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
          );
        }
    } else if (days == 'Wednesday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.wednesdayCloseHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__closing_hour') +
                  widget.shopInfo.shopSchedules!.wednesdayCloseHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    } else if (days == 'Thursday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.thursdayCloseHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__closing_hour') +
                  widget.shopInfo.shopSchedules!.thursdayCloseHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    } else if (days == 'Friday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.fridayCloseHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__closing_hour') +
                  widget.shopInfo.shopSchedules!.fridayCloseHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    } else if (days == 'Saturday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.saturdayCloseHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__closing_hour') +
                  widget.shopInfo.shopSchedules!.saturdayCloseHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    } else if (days == 'Sunday') {
        if (widget.shopInfoProvider.shopInfo.data!
            .shopSchedules!.sundayCloseHour != null) {
        return Text(
            Utils.getString(context, 'shop_info__closing_hour') +
                  widget.shopInfo.shopSchedules!.sundayCloseHour!,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.4),
        );
      }
    }
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    super.key,
    required this.data,
  });

  final ShopInfo data;
  @override
  Widget build(BuildContext context) {
    const Widget spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: data.defaultPhoto!,
      width: 50,
      height: 50,
      boxfit: BoxFit.cover,
      onTap: () {},
    );

    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16),
        child: Row(
          children: <Widget>[
            imageWidget,
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.name!,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: PsColors.mainColor,
                        ),
                  ),
                  spacingWidget,
                  InkWell(
                    child: Text(
                      data.aboutPhone1!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    ),
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse('tel://${data.aboutPhone1}'))) {
                        await launchUrl(Uri.parse('tel://${data.aboutPhone1}'));
                      } else {
                        throw 'Could not Call Phone Number 1';
                      }
                    },
                  ),
                  spacingWidget,
                  Row(
                    children: <Widget>[
                      Container(
                          child: const Icon(
                        Icons.email,
                      )),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      InkWell(
                        child: Text(data.codEmail!,
                            style: Theme.of(context).textTheme.bodyMedium),
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse('mailto:${data.email}'))) {
                            await launchUrl(Uri.parse('mailto:${data.email}'));
                          } else {
                            throw 'Could not launch ${data.email}';
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class _CustomerReviewListViewWidget extends StatelessWidget {
  const _CustomerReviewListViewWidget({
    required this.shopId,
    required this.shopInfoProvider,
    required this.shopRatingProvider,
  });

  final String shopId;
  final ShopInfoProvider shopInfoProvider;
  final ShopRatingProvider shopRatingProvider;
  @override
  Widget build(BuildContext context) {
    dynamic result;
    if (
        shopRatingProvider.ratingList.data != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: PsDimens.space44),
        child: Column(
          children: <Widget>[
            _CustomerReviewHeaderWidget(viewAllClicked: () async {
              result = await Navigator.pushNamed(
                  context, RoutePaths.shopRatingList,
                  arguments: shopId);

              if (result != null && result) {
                shopRatingProvider.refreshShopRatingList(shopId);
                shopInfoProvider.loadShopInfo(shopId);
              }
            }),
            CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (shopRatingProvider.ratingList.data != null ||
                            shopRatingProvider.ratingList.data!.isNotEmpty) {
                          return CustomerReviewListItem(
                            shopRating:
                                shopRatingProvider.ratingList.data![index],
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.transactionDetail,
                                  arguments: shopRatingProvider
                                      .ratingList.data![index]);
                            },
                          );
                        } else {
                          return null;
                        }
                      },
                      childCount: shopRatingProvider.ratingList.data!.length,
                    ),
                  ),
                ]),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}



class _CustomerReviewHeaderWidget extends StatefulWidget {
  const _CustomerReviewHeaderWidget({
    required this.viewAllClicked,
  });
  final Function? viewAllClicked;
  @override
  __CustomerReviewHeaderWidgetState createState() =>
      __CustomerReviewHeaderWidgetState();
}

class __CustomerReviewHeaderWidgetState
    extends State<_CustomerReviewHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space4,
            left: PsDimens.space20,
            right: PsDimens.space20,
            bottom: PsDimens.space4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                  Utils.getString(context, 'rating_list__customer_reviews'),
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Text(
              Utils.getString(context, 'customer_review__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: PsColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
