import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/provider/shop/new_shop_provider.dart';
import 'package:fluttermultigrocery/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../config/ps_colors.dart';
import '../../constant/ps_dimens.dart';
import '../../constant/route_paths.dart';
import '../../repository/shop_repository.dart';
import '../../utils/utils.dart';
import '../../viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import '../../viewobject/holder/shop_parameter_holder.dart';
import '../../viewobject/shop.dart';
import '../common/dialog/warning_dialog_view.dart';
import '../shop_list/item/shop_verticle_list_item.dart';

class NearestShopGoogleMapView extends StatefulWidget {
  const NearestShopGoogleMapView({super.key, 
    required this.latLng,
  });
  final LatLng latLng;
  @override
  State<NearestShopGoogleMapView> createState() =>
      _NearestShopGoogleMapViewState();
}

class _NearestShopGoogleMapViewState extends State<NearestShopGoogleMapView> {
  double _kmvalue = 0.5;
  ShopRepository? _repo;
  PersistentBottomSheetController? _bottomSheetController;
  PsValueHolder? psValueHolder;
  late NewShopProvider newShopProvider;
  String getMiles(String kmValue) {
    final double km = double.parse(kmValue);
    return (km * 0.621371).toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    _repo = Provider.of<ShopRepository>(context);
    final ShopParameterHolder holder =
        ShopParameterHolder().getShopNearYouParameterHolder();
    holder.lat = widget.latLng.latitude.toString();
    holder.lng = widget.latLng.longitude.toString();
    holder.miles = getMiles(_kmvalue.toString());
    return ChangeNotifierProvider<NewShopProvider>(
      create: (BuildContext context) {
        newShopProvider =
            NewShopProvider(repo: _repo, psValueHolder: psValueHolder);
        newShopProvider.loadShopList(holder);
        return newShopProvider;
      },
      child: PsWidgetWithAppBarWithNoProvider(
        appBarTitle: Utils.getString(context, 'shop_dashboard__shop_near_you'),
        actions: <Widget>[
          InkWell(
            child: Center(
              child: Text(
                Utils.getString(context, 'map_pin__reset'),
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(color: PsColors.mainColorWithWhite),
              ),
            ),
            onTap: () async {
              final ShopParameterHolder holder =
                  ShopParameterHolder().getShopNearYouParameterHolder();
              holder.lat = widget.latLng.latitude.toString();
              holder.lng = widget.latLng.longitude.toString();
              setState(() {
                _kmvalue = 0.5;
              });
              holder.miles = getMiles(_kmvalue.toString());
              await newShopProvider.resetShopList(holder);

              Future<void>.delayed(const Duration(seconds: 1), () {
                if (newShopProvider.shopList.data == null ||
                    newShopProvider.shopList.data!.isEmpty) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return WarningDialog(
                          message: Utils.getString(context, 'no_shop_found'),
                          onPressed: () {},
                        );
                      });
                }
              });
            },
          ),
          const SizedBox(
            width: PsDimens.space20,
          ),
          InkWell(
            child: Center(
              child: Text(
                Utils.getString(context, 'map_pin__apply'),
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(color: PsColors.mainColorWithWhite),
              ),
            ),
            onTap: () async {
              final ShopParameterHolder holder =
                  ShopParameterHolder().getShopNearYouParameterHolder();
              holder.lat = widget.latLng.latitude.toString();
              holder.lng = widget.latLng.longitude.toString();
              holder.miles = getMiles(_kmvalue.toString());
              await newShopProvider.resetShopList(holder);

              Future<void>.delayed(const Duration(seconds: 1), () {
                if (newShopProvider.shopList.data == null ||
                    newShopProvider.shopList.data!.isEmpty) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return WarningDialog(
                          message: Utils.getString(context, 'no_shop_found'),
                          onPressed: () {},
                        );
                      });
                }
              });
            },
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
        ],
        child: Consumer<NewShopProvider>(
            builder: (BuildContext context, NewShopProvider provider, _) {
          return Column(
            children: <Widget>[
              Expanded(
                  child: GoogleMap(
                onTap: (LatLng latlng) {
                  _bottomSheetController!.close();
                },
                initialCameraPosition: CameraPosition(
                  target: widget.latLng,
                  zoom: 15,
                ),
                circles: <Circle>{
                  Circle(
                    circleId: const CircleId('circle1'),
                    center: widget.latLng,
                    radius: _kmvalue * 1000,
                    fillColor: const Color.fromARGB(185, 157, 202, 238),
                    strokeColor: const Color.fromARGB(184, 90, 241, 103),
                    strokeWidth: 1,
                  ),
                },
                markers: <Marker>{
                  Marker(
                    markerId: const MarkerId('currentPosition'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                    onTap: () {
                      _bottomSheetController!.close();
                    },
                    position: widget.latLng,
                  ),
                  // ...nearestShopMarkerList(provider.shopList.data),
                  ...provider.shopList.data!.map(
                    (Shop shop) => Marker(
                      markerId: MarkerId(shop.id!),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      onTap: () {
                        _bottomSheetController = showBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, RoutePaths.shop_dashboard,
                                      arguments: ShopDataIntentHolder(
                                          shopId: shop.id,
                                          shopName: shop.name));
                                },
                                child: ShopVerticleListItemWidget(
                                  shop: shop,
                                ),
                              );
                            });
                      },
                      position: LatLng(
                          double.parse(shop.lat!), double.parse(shop.lng!)),
                    ),
                  )
                },
              )),
              Container(
                color: PsColors.backgroundColor,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, top: 10),
                        child: Text(
                            '${Utils.getString(context, 'map_pin__browsing_around')} $_kmvalue km'),
                      ),
                      Slider(
                        divisions: 19,
                        activeColor: PsColors.mainColor,
                        value: _kmvalue,
                        onChanged: (double val) {
                          setState(() {
                            _kmvalue = val;
                          });
                        },
                        max: 50,
                        min: .5,
                        label: '$_kmvalue km',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('0.5 km'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('50 km'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
            ],
          );
        }),
      ),
    );
  }

  dynamic nearestShopMarkerList(List<Shop> shopList) {
    if (shopList.isNotEmpty) {
      return shopList.map(
        (Shop shop) => Marker(
          markerId: MarkerId(shop.id!),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () {
            _bottomSheetController = showBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RoutePaths.shop_dashboard,
                          arguments: ShopDataIntentHolder(
                              shopId: shop.id, shopName: shop.name));
                    },
                    child: ShopVerticleListItemWidget(
                      shop: shop,
                    ),
                  );
                });
          },
          position: LatLng(double.parse(shop.lat!), double.parse(shop.lng!)),
        ),
      );
    }
  }
}
