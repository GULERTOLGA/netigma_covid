import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'feature.dart';

class MapSample extends StatefulWidget {
  final String sessionid;

  const MapSample({Key key, this.sessionid}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30, 39),
    zoom: 0,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(36, 39),
      tilt: 59.440717697143555,
      zoom:0);

  String _mapStyle;



  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/style.txt').then((string) {
      _mapStyle = string;
    });

    geoJson(widget.sessionid);
  }


  Future<FeatureCollection> geoJson(String sessionid) async {
    var parameters = <String, dynamic>{
      "queryName": "queryName",
    };

    List<String> queryString = parameters
        .map((i, v) => MapEntry(i, v))
        .keys
        .toList()
        .map((a) => "$a=${Uri.encodeComponent(parameters[a].toString())}")
        .toList();

    var url = "http://ssltest.netcad.comt.tr/covid//gisapi/query/query?QueryName=coronawho.Sorgusu&sessionid=${sessionid}&filter=coronawho.location%20=%27worldwide%27&enableCache=true";
    var response = await http.get(url);

    if (response.body != null ) {
      var queryResultResponse =
      FeatureCollection.fromJson(json.decode(response.body));
      return queryResultResponse;
    } else
      return null;
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
        ].toSet(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(_mapStyle);

        },
      ),

    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}