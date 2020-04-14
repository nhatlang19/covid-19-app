import 'package:covid19/bloc/map_country/map_country_bloc.dart';
import 'package:covid19/bloc/map_country/map_country_state.dart';
import 'package:covid19/widget/show_map/scale_layer_plugin_option.dart';
import 'package:covid19/widget/show_map/zoombuttons_plugin_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class ShowMap extends StatefulWidget {
  @override
  MapState createState() => MapState();
}

class MapState extends State<ShowMap> {
  var circleMarkers = <CircleMarker>[];
  MapCountryBloc _mapCountryBloc;

  @override
  void initState() {
    _mapCountryBloc = BlocProvider.of<MapCountryBloc>(context);
    _mapCountryBloc.listen((onData) {
      if (onData is MapCountriesLoaded) {
        onData.countries.forEach((country) {
          if (country.info != null) {
            circleMarkers.add(
              CircleMarker(
                  point: LatLng(country.info.lat, country.info.long),
                  color: Colors.red.withOpacity(0.7),
                  borderColor: Colors.red.withOpacity(0.7),
                  borderStrokeWidth: 1,
                  useRadiusInMeter: true,
                  radius: 50000 // 2000 meters | 2 km
                  ),
            );
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
          center: new LatLng(14.0583, 108.2772),
          zoom: 6.0,
          plugins: [
            ScaleLayerPlugin(),
            ZoomButtonsPlugin(),
          ],
          maxZoom: 10.0,
          minZoom: 3.0),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.pngg",
          subdomains: ['a', 'b', 'c'],
          tileProvider: NonCachingNetworkTileProvider(),
        ),
        CircleLayerOptions(circles: circleMarkers),
        ZoomButtonsPluginOption(
            minZoom: 3,
            maxZoom: 10,
            mini: true,
            padding: 10,
            alignment: Alignment.bottomRight),
        ScaleLayerPluginOption(
          lineColor: Colors.blue,
          lineWidth: 2,
          textStyle: TextStyle(color: Colors.blue, fontSize: 12),
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
