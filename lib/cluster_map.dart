import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http2;
import 'dart:convert';

import 'feature.dart';

class MapSample extends StatefulWidget {
  final String sessionid;

  const MapSample({Key key, this.sessionid}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with  AutomaticKeepAliveClientMixin<MapSample>{
  ClusterManager _managerex;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = Set();

  final CameraPosition _parisCameraPosition =
      CameraPosition(target: LatLng(36.856613, 45.352222), zoom: 3.0);

  List<ClusterItem<Place>> items = [];

  String _mapStyle;

  List<int> values = [];

  int subTotal = 0;

  get http => null;
  @override
  void initState() {

    print("map init state");
    print(this.mounted);

    super.initState();

    rootBundle.loadString('assets/style.txt').then((string) {
      _mapStyle = string;
    });

    geoJson(widget.sessionid).then((a) {
      var features = a.features;
      items.clear();
      values.clear();

      subTotal = 0;

      for (int i = 0; i < a.features.length; i++) {
        try {
          var f = features[i];
          var total = int.parse(f.properties["Total"]);
          if(!values.contains(total)) {
            values.add(total);
            subTotal += total;          }
        }
        catch(a){
        }
      }

      for (int i = 0; i < a.features.length; i++) {
        try {
          var f = features[i];
          addMarker(f,i);
        }
        catch(a){
        }
      }

      Future.delayed(Duration(milliseconds: 300),(){


        setState(() {
          items = items;
        });


      });

    });
  }



  Future<void> addMarker(f,i) async{

    var name = f.properties["Name"];
    var total = f.properties["Total"];
    var lat = f.centroid.latitude;
    var lng = f.centroid.longitude;
    //items.add(ClusterItem( LatLng(lat, lng), item: Place(name: name)));
    var perc = getPercentage(int.parse(total)).round();
    print("$name : $total : ${perc.round()}");
    perc =  perc == 0 ? 1 : perc;
    perc = max(perc, 10);

    this.markers.add(Marker(
        markerId: new MarkerId(i.toString()),
        position:   LatLng(lat, lng),
        icon: await _getMarkerBitmap((perc * 8).round(), text:total)// getPercentage(total).toString())

    ));

  }

  double getPercentage(int value)
  {
    return (value * 100 / subTotal);
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

    var url =
        "https://covid19.netigma.io/covid/gisapi/query/geojson?queryName=geocases.Sorgusu&SessionID=$sessionid&GetCentroid=true&enableCache=true";
    print(url);
    final response = await http2.get(url);

    if (response.body != null) {
      var queryResultResponse =
          FeatureCollection.fromJson(json.decode(response.body));
      return queryResultResponse;
    } else
      return null;
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder, initialZoom: _parisCameraPosition.zoom);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _parisCameraPosition,
              markers: markers,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                controller.setMapStyle(_mapStyle);
              },
             ),
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String text}) async {
    assert(size != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.red.withOpacity(0.7);
    final Paint paint2 = Paint()..color = Colors.white.withOpacity(0.7);

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(

            fontSize: min(size / 4, 40),
            color: Colors.black,
            fontWeight: FontWeight.bold),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Place {
  final String name;
  final bool isClosed;

  const Place({this.name, this.isClosed = false});

  @override
  String toString() {
    // TODO: implement toString
    return 'Place $name (closed : $isClosed)';
  }
}
