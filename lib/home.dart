import 'package:flutter/material.dart';
import 'package:geojson/geojson.dart';
import 'package:geomaps/api/client.dart' as httpClient;
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' as math;
import 'package:geopoint/geopoint.dart';
import 'package:latlong/latlong.dart';
import 'package:pedantic/pedantic.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dataGeo;
  final polygons = <Polygon>[];

  @override
  void initState() {
    super.initState();
    loadGeoData();
  }

  Future<void> loadGeoData() async {
    String geo = await httpClient.getGeoMap();
    print('new fetch: $geo');
    setState(() {
      dataGeo = geo;
    });
    final geojson = GeoJson();
    geojson.processedPolygons.listen((GeoJsonPolygon polygon) {
      final geoSerie = GeoSerie(
          type: GeoSerieType.polygon,
          name: polygon.geoSeries[0].name,
          geoPoints: <GeoPoint>[]);
      for (final serie in polygon.geoSeries) {
        geoSerie.geoPoints.addAll(serie.geoPoints);
      }
      final color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(0.3);
      final poly = Polygon(
        points: geoSerie.toLatLng(ignoreErrors: true),
        borderColor: Colors.red,
        color: color,
        borderStrokeWidth: 1.0,
      );
      setState(() => polygons.add(poly));
    });
    geojson.endSignal.listen((bool _) => geojson.dispose());
    final nameProperty = "provinsi";
    unawaited(geojson.parse(geo, nameProperty: nameProperty, verbose: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeoJSON Maps'),
      ),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          center: LatLng(-2.9339376,115.9458253),
          zoom: 4.8,
          rotation: 90,
          onTap: (loc) {
            print('loc: $loc');
          }
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          PolygonLayerOptions(
            polygons: polygons,
          ),
        ],
      ),
    );
  }
}
