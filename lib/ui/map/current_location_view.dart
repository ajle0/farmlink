import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/delivery_cost/delivery_cost_provider.dart';
import 'package:fluttermultigrocery/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultigrocery/provider/user/user_provider.dart';
import 'package:fluttermultigrocery/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultigrocery/utils/ps_progress_dialog.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/basket.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/map_pin_call_back_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/map_pin_intent_holder.dart';
import 'package:geolocator/geolocator.dart' hide ServiceStatus;
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

 
//import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    super.key,
    required this.provider,
    required this.shopInfoProvider,
    required this.basketList,
    required this.valueHolder,

    /// If set, enable the FusedLocationProvider on Android
    required this.androidFusedLocation,
    required this.textEditingController,
    required this.deliveryCostCalculate,
    this.userProvider,

    // @required this.userLatLng
  });

  final DeliveryCostProvider provider;
  final ShopInfoProvider shopInfoProvider;
  final List<Basket> basketList;
  final bool androidFusedLocation;
  final TextEditingController textEditingController;
  final Function deliveryCostCalculate;
  final PsValueHolder valueHolder;
  final UserProvider? userProvider;
  // final LatLng userLatLng;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  // Position _lastKnownPosition;
  Position? _currentPosition;
  String address = '';
  LatLng? _latlng;
  bool bindDataFirstTime = true;
  final MapController mapController = MapController();
  final double zoomLevel = 17;
  @override
  void initState() {
    super.initState();

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  // @override
  // void didUpdateWidget(Widget oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   setState(() {
  //     // _lastKnownPosition = null;
  //     _currentPosition = null;
  //   });

  //   _initLastKnownLocation().then((_) => _initCurrentLocation());
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    // Position position;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   final Geolocator geolocator = Geolocator()
    //     ..forceAndroidLocationManager = !widget.androidFusedLocation;
    //   position = await geolocator.getLastKnownPosition(
    //       desiredAccuracy: LocationAccuracy.best);
    // } on PlatformException {
    //   position = null;
    // }

    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return;
    // }

    // setState(() {
    // _lastKnownPosition = position;
    // });
  }

  dynamic loadAddress() async {
    if (_currentPosition != null) {
      _latlng ??=
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      widget.userProvider!.setUserLatLng(_latlng!);
      setState(() {
        mapController.move(_latlng!, zoomLevel);
      });
      if (widget.textEditingController.text == '') {
          await placemarkFromCoordinates(
                _currentPosition!.latitude, _currentPosition!.longitude)
            .then((List<Placemark> placemarks) {
          final Placemark place = placemarks[0];
          setState(() {
            address =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
            widget.textEditingController.text = address;
          });
        }).catchError((dynamic e) {
          debugPrint(e);
        });
      } else {
        address = widget.textEditingController.text;
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // dynamic _initCurrentLocation() {
  //   Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.medium,
  //           forceAndroidLocationManager: !widget.androidFusedLocation)
  //       .then((Position position) {
  //     if (mounted) {
  //       setState(() {
  //         _currentPosition = position;
  //         if (widget.userProvider!.hasLatLng(widget.valueHolder)) {
  //           _latlng =
  //               LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
  //           widget.userProvider!.setUserLatLng(_latlng!);
  //           mapController.move(_latlng!, zoomLevel);
  //         }
  //       });
  //     }
  //   }).catchError((Object e) {
  //     print(e);
  //   });
  // }

   // Platform messages are asynchronous, so we initialize in an async method.
  dynamic _initCurrentLocation() {
    Geolocator.checkPermission().then((LocationPermission permission) {
      if (permission == LocationPermission.denied) {
        Geolocator.requestPermission().then((LocationPermission permission) {
          if (permission == LocationPermission.denied) {
          } else {
            Geolocator
                .getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.medium,
                    forceAndroidLocationManager: false)
                .then((Position position) {
              _currentPosition = position;
              loadAddress();
            }).catchError((Object e) {
              print(e);
            });
          }
        });
      } else {
        Geolocator
            .getCurrentPosition(
                desiredAccuracy: LocationAccuracy.medium,
                forceAndroidLocationManager: !widget.androidFusedLocation)
            .then((Position position) {
          setState(() {
            _currentPosition = position;
            loadAddress();
          });
        }).catchError((Object e) {
          print(e);
        });
      }
    });
  }

  dynamic _loadCurrentLocation() async {
    await PsProgressDialog.showDialog(context);
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            forceAndroidLocationManager: !widget.androidFusedLocation)
        .then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          if (widget.userProvider!.hasLatLng(widget.valueHolder)) {
            _latlng =
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
            widget.userProvider!.setUserLatLng(_latlng!);
            mapController.move(_latlng!, zoomLevel);
          }
        });
      }
    }).catchError((Object e) {
      print(e);
    });
    PsProgressDialog.dismissDialog();
  }

  dynamic _handleTap(
      MapController mapController, bool isUserCurrentLocation) async {
    String tmpLat = _latlng != null
        ? _latlng!.latitude.toString()
        : widget.valueHolder.lat!;
    String tmpLng = _latlng != null
        ? _latlng!.longitude.toString()
        : widget.valueHolder.lng!;
    if (isUserCurrentLocation) {
      tmpLat = _currentPosition!.latitude.toString();
      tmpLng = _currentPosition!.longitude.toString();
    }

    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP, mapLat: tmpLat, mapLng: tmpLng));
    if (result != null && result is MapPinCallBackHolder) {
      setState(() {
        _latlng = result.latLng;
        widget.userProvider!.setUserLatLng(_latlng!);
        mapController.move(result.latLng!, zoomLevel);
        widget.textEditingController.text = result.address!;
        if (widget.shopInfoProvider.shopInfo.data!.isArea == PsConst.ZERO) {
          widget.deliveryCostCalculate(
            widget.provider,
            widget.basketList,
            _latlng!.latitude.toString(),
            _latlng!.longitude.toString(),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadAddress();

    final Widget addressHeaderWidget = Row(
      children: <Widget>[
        Text(Utils.getString(context, 'edit_profile__address'),
            style: Theme.of(context).textTheme.bodyLarge),
        Text(' *',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: PsColors.mainColor))
      ],
    );

    return FutureBuilder<LocationPermission>(
        future: Geolocator.checkPermission(),
        builder:
            (BuildContext context, AsyncSnapshot<LocationPermission> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == LocationPermission.denied) {
            // return const Text('Allow access to the location services for this App using the device settings.');
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(
                    PsDimens.space12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      addressHeaderWidget,
                      _GpsButtonWidget(
                        mapController: mapController,
                        handleTap: _handleTap,
                        loadAddress: _loadCurrentLocation,
                      ),
                    ],
                  ),
                ),

                _MapViewWidget(
                  mapController: mapController,
                  latlng: _latlng != null
                      ? _latlng!
                      : LatLng(double.parse(widget.valueHolder.lat!),
                          double.parse(widget.valueHolder.lng!)),
                  handleTap: _handleTap,
                  zoomLevel: zoomLevel,
                )

                // if (_latlng == null && _currentPosition == null)
                //   Padding(
                //       padding: const EdgeInsets.only(
                //           right: PsDimens.space8,
                //           left: PsDimens.space8,
                //           bottom: PsDimens.space12),
                //       child: Container(
                //         height: 250,
                //         child: FlutterMap(
                //           mapController: mapController,
                //           options: MapOptions(
                //               center: widget.userLatLng,
                //               zoom: 15.0,
                //               onTap: (LatLng latLng) {
                //                 FocusScope.of(context)
                //                     .requestFocus(FocusNode());
                //                 _handleTap(mapController);
                //               }),
                //           layers: <LayerOptions>[
                //             TileLayerOptions(
                //               urlTemplate:
                //                   'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                //             ),
                //             MarkerLayerOptions(markers: <Marker>[
                //               Marker(
                //                 width: 80.0,
                //                 height: 80.0,
                //                 point: widget.userLatLng,
                //                 builder: (BuildContext ctx) => Container(
                //                   child: IconButton(
                //                     icon: Icon(
                //                       Icons.location_on,
                //                       color: Colors.red,
                //                     ),
                //                     iconSize: 45,
                //                     onPressed: () {},
                //                   ),
                //                 ),
                //               )
                //             ])
                //           ],
                //         ),
                //       ))
                // else
                //   Container()
                // ,Text( _lastKnownPosition.toString()),
                // Text(_currentPosition.toString()),
                // Text(address),
              ],
            ),
          );
        });
  }
}

class _MapViewWidget extends StatelessWidget {
  const _MapViewWidget({
    required this.mapController,
    required this.latlng,
    required this.handleTap,
    required this.zoomLevel,
  });

  final MapController mapController;
  final LatLng latlng;
  final void Function(MapController, bool) handleTap;
  final double zoomLevel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: PsDimens.space8,
        right: PsDimens.space8,
        bottom: PsDimens.space12,
      ),
      child: SizedBox(
        height: 250,
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: latlng,     // ← changed
            initialZoom: zoomLevel,    // ← changed
            onTap: (tapPos, latLng) {
              FocusScope.of(context).unfocus();
              handleTap(mapController, false);
            },
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.yourcompany.yourapp',
            ),
            MarkerLayer(
              markers: <Marker>[
                Marker(
                  point: latlng,
                  width: 80,
                  height: 80,
                  child: const Icon(      // ← swapped builder → child
                    Icons.location_on,
                    color: Colors.red,
                    size: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GpsButtonWidget extends StatelessWidget {
  const _GpsButtonWidget({
    required this.mapController,
    required this.handleTap,
    required this.loadAddress,
  });

  final MapController mapController;
  final Function handleTap;
  final Function loadAddress;

  @override
  Widget build(BuildContext context) {
    
    Future<void> checkPermissionAndNavigate() async {
      final ServiceStatus serviceStatus =
          await Permission.locationWhenInUse.serviceStatus;
      final bool isGpsOn = serviceStatus == ServiceStatus.enabled;
      if (!isGpsOn) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return WarningDialog(
                message: Utils.getString(context, 'map_pin__open_gps'),
                onPressed: () {},
              );
            });
        return;
      }

      final PermissionStatus status =
          await Permission.locationWhenInUse.request();
      if (status == PermissionStatus.granted) {
        await loadAddress();
        handleTap(mapController, true);
      } else if (status == PermissionStatus.denied) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return WarningDialog(
                message: Utils.getString(context, 'map_pin__open_gps'),
                onPressed: () {},
              );
            });
      } else if (status == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
      }
    }

    return Container(
      height: PsDimens.space44,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: PsDimens.space4),
      decoration: BoxDecoration(
        color: PsColors.baseDarkColor,
        borderRadius: BorderRadius.circular(PsDimens.space4),
        border: Border.all(color: PsColors.mainDividerColor),
      ),
      child: InkWell(
          child: SizedBox(
            height: double.infinity,
            width: PsDimens.space44,
            child: Icon(
              Icons.gps_fixed,
              color: PsColors.iconColor,
              size: PsDimens.space20,
            ),
          ),
          onTap: () async => checkPermissionAndNavigate()),
    );
  }
}
