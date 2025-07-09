import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/holder/map_pin_call_back_holder.dart';

class MapPinView extends StatefulWidget {
  const MapPinView({
    super.key,
    required this.flag,
    required this.maplat,
    required this.maplng,
  });

  final String flag;
  final String maplat;
  final String maplng;

  @override
  _MapPinViewState createState() => _MapPinViewState();
}

class _MapPinViewState extends State<MapPinView> {
  late LatLng _latlng;
  String _address = '';
  static const double _zoom = 17.0;

  @override
  void initState() {
    super.initState();
    _latlng = LatLng(
      double.parse(widget.maplat),
      double.parse(widget.maplng),
    );
    _updateAddress();
  }

  Future<void> _updateAddress() async {
    try {
      final places = await placemarkFromCoordinates(
        _latlng.latitude,
        _latlng.longitude,
      );
      final place = places.first;
      setState(() {
        _address =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    } catch (e) {
      // gracefully ignore lookup failures
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always supply a non-null List<Widget> for actions
    final actions = widget.flag == PsConst.PIN_MAP
        ? <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  MapPinCallBackHolder(
                    address: _address,
                    latLng: _latlng,
                  ),
                );
              },
              child: Text(
                Utils.getString(context, 'map_pin__pick_location'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: PsColors.mainColorWithWhite),
              ),
            ),
            const SizedBox(width: PsDimens.space16),
          ]
        : <Widget>[];

    return PsWidgetWithAppBarWithNoProvider(
      appBarTitle: Utils.getString(context, 'map_pin__title'),
      actions: actions,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _latlng,
                  initialZoom: _zoom,
                  onTap: (_, tappedLatLng) {
                    if (widget.flag == PsConst.PIN_MAP) {
                      setState(() => _latlng = tappedLatLng);
                      _updateAddress();
                    }
                  },
                ),
                children: <Widget>[
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.panacea_soft.fluttermultigrocery',
                  ),
                  MarkerLayer(
                    markers: <Marker>[
                      Marker(
                        point: _latlng,
                        width: PsDimens.space48,
                        height: PsDimens.space48,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: PsDimens.space44,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
