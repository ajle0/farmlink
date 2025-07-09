import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/provider/shop/new_shop_provider.dart';
import 'package:fluttermultigrocery/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:fluttermultigrocery/ui/shop_list/item/shop_verticle_list_item.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/shop_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/shop.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../constant/ps_dimens.dart';
import '../../constant/route_paths.dart';
import '../../repository/shop_repository.dart';
import '../../utils/utils.dart';
import '../../viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import '../common/dialog/warning_dialog_view.dart';

class NearestShopView extends StatefulWidget {
  const NearestShopView({super.key, 
    required this.latLng,
  });
  final LatLng latLng;
  @override
  _NearestShopViewState createState() => _NearestShopViewState();
}

class _NearestShopViewState extends State<NearestShopView> {
  double _kmValue = 10;
  String? address;
  ShopRepository? _repo;
  PsValueHolder? psValueHolder;
  Marker? currentLocation;
  late NewShopProvider newShopProvider;
  PersistentBottomSheetController? _bottomSheetController;

  Marker? shopInfo;
  // List<String> seekBarValues = <String>[
  //   '0.5',
  //   '1',
  //   '2.5',
  //   '5',
  //   '10',
  //   '25',
  //   '50',
  //   '100',
  //   '200',
  //   '500',
  //   'All'
  // ];

  String getMiles(String kmValue) {
    final double km = double.parse(kmValue);
    return (km * 0.621371).toStringAsFixed(3);
  }

  @override
  void initState() {
    print('LatLng : ${widget.latLng}');
    super.initState();
    currentLocation = Marker(
        point: widget.latLng,
        child: IconButton(
            onPressed: () {
              _bottomSheetController?.close();
            },
            icon: Icon(
              Icons.location_on,
              color: PsColors.mainColor,
              size: 45,
            )));

    // loadAddress();
  }


  @override
  Widget build(BuildContext context) {
    _repo = Provider.of<ShopRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    final ShopParameterHolder holder =
        ShopParameterHolder().getShopNearYouParameterHolder();
    holder.lat = widget.latLng.latitude.toString();
    holder.lng = widget.latLng.longitude.toString();
    holder.miles = getMiles(_kmValue.toString());
    return ChangeNotifierProvider<NewShopProvider>(
      create: (BuildContext context) {
        newShopProvider =
            NewShopProvider(repo: _repo, psValueHolder: psValueHolder);
        newShopProvider.loadShopList(holder);
        return newShopProvider;
      },
      child: PsWidgetWithAppBarWithNoProvider(
        appBarTitle: '',
        actions: <Widget>[
          InkWell(
            child: Center(
              child: Text(
                Utils.getString(context, 'RESET'),
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
                _kmValue = 10;
              });
              holder.miles = getMiles(_kmValue.toString());
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
                Utils.getString(context, 'APPLY'),
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
              holder.miles = getMiles(_kmValue.toString());
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
          final List<Shop> shopList = provider.shopList.data!;
          return Column(
            children: <Widget>[
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    onTap: (TapPosition val, __) {
                      _bottomSheetController!.close();
                    },
                    maxZoom: 18,
                    initialCenter: widget.latLng,
                    initialZoom: 17,
                    // onTap: _handleTap,
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: <String>['a', 'b', 'c'],
                    ),
                    CircleLayer(
                      circles: <CircleMarker>[
                        CircleMarker(
                          point: widget.latLng,
                          radius: _kmValue * 1000,
                          useRadiusInMeter: true,
                          color: const Color.fromARGB(185, 157, 202, 238),
                        )
                      ],
                    ),
                    MarkerLayer(
                      markers: <Marker>[
                        currentLocation!,
                        ...nearestShopMarkerList(shopList),
                      ],
                    ),
                  ],
                ),
              ),
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
                            '${Utils.getString(context, 'map_pin__browsing_around')} $_kmValue km'),
                      ),
                      Slider(
                        divisions: 9,
                        activeColor: PsColors.mainColor,
                        value: _kmValue,
                        onChanged: (double val) {
                          setState(() {
                            _kmValue = val;
                          });
                        },
                        max: 50,
                        min: .5,
                        label: '$_kmValue km',
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

  List<Marker> nearestShopMarkerList(List<Shop> shopList) {
    List<Marker> marketList = <Marker>[];
    if (shopList.isNotEmpty) {
      marketList = shopList
          .map((Shop shop) => Marker(
                width: 60,
                height: 60,
                point: LatLng(double.parse(shop.lat!), double.parse(shop.lng!)),
                child: IconButton(
                  onPressed: () {
                    _bottomSheetController = showBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, RoutePaths.shop_dashboard,
                                  arguments: ShopDataIntentHolder(
                                      shopId: shop.id, shopName: shop.name));
                            },
                            child: ShopVerticleListItemWidget(
                              shop: shop,
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    FontAwesome.map,
                    size: 35,
                    color: Color.fromARGB(255, 1, 114, 39),
                  ),
                ),
              ))
          .toList();
    }
    return marketList;
  }
}
