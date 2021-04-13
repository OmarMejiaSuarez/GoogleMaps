import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late maps.GoogleMapController mapController;
  Set<maps.Marker> _markers = HashSet<maps.Marker>();
  final Set<maps.Polyline> _polyline = Set();

  int _markerIdCounter = 1;
  final maps.LatLng _center = const maps.LatLng(10.9878, -74.7955);

  void _onMapCreated(maps.GoogleMapController controller) {
    mapController = controller;
  }

  void _setMarkers(
      maps.LatLng point, String titleMarker, String descriptionMarker) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      _markers.add(
        maps.Marker(
            markerId: maps.MarkerId(markerIdVal),
            position: point,
            infoWindow: maps.InfoWindow(
                title: '$titleMarker', snippet: '$descriptionMarker')),
      );
    });
  }

  void _setRoute(maps.LatLng pointInital, maps.LatLng pointFinal) {
    List<maps.LatLng> _latlng = [];
    _latlng.add(pointInital);
    _latlng.add(maps.LatLng(10.9800, -74.7995));
    _latlng.add(maps.LatLng(10.9878, -74.7955));
    _latlng.add(pointFinal);
    _drawPoliLine(_latlng);
  }

  void _drawPoliLine(List<maps.LatLng> _latlng) {
    setState(() {
      _polyline.add(maps.Polyline(
        polylineId: maps.PolylineId(_center.toString()),
        visible: true,
        //latlng is List<LatLng>
        points: _latlng,
        color: Colors.blue,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    _setMarkers(
        maps.LatLng(10.9878, -74.8000), 'Punto inicial', 'punto de partida');
    _setMarkers(
        maps.LatLng(10.9878, -74.7889), 'Punto final', 'punto de llegada');
    _setRoute(maps.LatLng(10.9878, -74.8000), maps.LatLng(10.9878, -74.7889));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: maps.GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: maps.CameraPosition(
            target: _center,
            zoom: 15,
          ),
          markers: _markers,
          polylines: _polyline,
        ),
      ),
    );
  }
}
