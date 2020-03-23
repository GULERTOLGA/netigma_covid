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
import 'package:netigma_covid/meta/country_model.dart';
import 'dart:convert';

import 'feature.dart';

class MapSample extends StatefulWidget {
  final String sessionid;

  const MapSample({Key key, this.sessionid}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample>
    with AutomaticKeepAliveClientMixin<MapSample> {
  ClusterManager _managerex;

  Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> _controller2 = Completer();
  Completer<GoogleMapController> _controller3 = Completer();
  Completer<GoogleMapController> _controller4 = Completer();

  Set<Marker> allCasesMarkers = Set();
  Set<Marker> newCasesMarkers = Set();
  Set<Marker> newDeathsMarkers = Set();
  Set<Marker> allDeathsMarkers = Set();
  Set<Marker> recoveredMarkers = Set();

  final CameraPosition _parisCameraPosition =
      CameraPosition(target: LatLng(36.856613, 45.352222), zoom: 3.0);

  String _mapStyle;
  String _mapStyle2;
  String _mapStyle3;
  String _mapStyle4;

  List<int> values = [];

  int subTotal = 0;
  List<CountryModel> countries = [];

  bool _loading = false;

  var totals = <String,int>{
    "total":0,
    "newCases":0,
    "deaths":0,
    "newDeaths":0,
    "recovered":0,
  };

  @override
  void initState() {
    super.initState();
    setStyles();
    setState(() {
      _loading = true;
    });

    totals = <String,int>{
      "total":0,
      "newCases":0,
      "totalDeaths":0,
      "newDeaths":0,
      "recovered":0,
    };

    geoJson(widget.sessionid).then((a) {
      var features = a.features;
      values.clear();
      countries.clear();
      subTotal = 0;

      for (int i = 0; i < a.features.length; i++) {
        try {
          var f = features[i];
          var name = f.properties["Name"];
          var total = f.properties["Total"];
          var newCases = f.properties["Newcases"];
          var deaths = f.properties["Deaths"];
          var newDeaths = f.properties["Newdeaths"];
          var recovered = f.properties["Recovered"];
          var lat = f.centroid.latitude;
          var lng = f.centroid.longitude;

          var cm = CountryModel(
            name: name,
            total: int.parse(total.toString()),
            newCases: int.parse(newCases.toString()),
            totalDeaths: int.parse(deaths.toString()),
            newDeaths: int.parse(newDeaths.toString()),
            recovered: int.parse(recovered.toString()),
            lat:lat.toDouble(),
            lng:lng.toDouble(),
          );

          totals["total"] += cm.total;
          totals["newCases"] += cm.newCases;
          totals["totalDeaths"] += cm.totalDeaths;
          totals["newDeaths"] += cm.newDeaths;
          totals["recovered"] += cm.recovered;

          countries.add(cm);
        } catch (a) {}
      }

      fillMarkers();

      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _loading = false;
        });
      });
    });
  }

  void fillMarkers() async {
    for(int i = 0; i <countries.length; i++) {
      var c = countries[i];
      if(c.total > 0) {
        var totalSize = getPercentage(c.total, "total");
        Marker m1 = await getMarker(
            i, c.name, c.total, totalSize, c.lat, c.lng);
        allCasesMarkers.add(m1);
      }

      if(c.newCases > 0) {
        var newCasesSize = getPercentage(c.newCases, "newCases");
        Marker m2 = await getMarker(
            i, c.name, c.newCases, newCasesSize, c.lat, c.lng);
        newCasesMarkers.add(m2);
      }

      if(c.totalDeaths > 0) {
        var totalDeathsSize = getPercentage(c.totalDeaths, "totalDeaths");
        Marker m3 = await getMarker(
            i, c.name, c.totalDeaths, totalDeathsSize, c.lat, c.lng);
        allDeathsMarkers.add(m3);
      }

      if(c.newDeaths > 0) {
        var newDeathsSzie = getPercentage(c.newDeaths, "newDeaths");
        Marker m4 = await getMarker(
            i, c.name, c.newDeaths, newDeathsSzie, c.lat, c.lng);
        newDeathsMarkers.add(m4);
      }

      if(c.recovered > 0) {
        var recoveredSize = getPercentage(c.recovered, "recovered");
        Marker m5 = await getMarker(
            i, c.name, c.recovered, recoveredSize, c.lat, c.lng);
        recoveredMarkers.add(m5);
      }
    }

    setState(() {

    });


  }

  void setStyles() {
    rootBundle.loadString('assets/style.txt').then((string) {
      _mapStyle = string;
    });

    rootBundle.loadString('assets/style2.txt').then((string) {
      _mapStyle2 = string;
    });

    rootBundle.loadString('assets/style3.txt').then((string) {
      _mapStyle3 = string;
    });
  }

  Future<Marker> getMarker(int index, String name, int total , int size, double lat, double lng) async {

  return Marker(
        markerId: new MarkerId(index.toString()),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: name, snippet: total.toString()),
        icon: await _getMarkerBitmap(size,
            text: total.toString())/// getPercentage(total).toString())

        );
  }

  int getPercentage(int value, String property) {
    var perc = (value * 100 / totals[property]);
    perc = perc == 0 ? 1 : perc;
    perc = max(perc, 10);
    return (perc * 8).round();
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var left = size.width / 2 - 25;
    var top = size.height / 2 - 25;
    return DefaultTabController(
        length: 5,
        child: new Scaffold(
            appBar: AppBar(
              title: new TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    icon: new Text("All Cases"),
                  ),
                  Tab(
                    icon: new Text("New Cases"),
                  ),
                  Tab(
                    icon: new Text("New Deaths"),
                  ),
                  Tab(
                    icon: new Text("All Deaths"),
                  ),
                  Tab(
                    icon: new Text("Recovered"),
                  )
                ],
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.red,
              ),
            ),
            body: TabBarView(children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _parisCameraPosition,
                markers: allCasesMarkers,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle);
                },
              ),
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _parisCameraPosition,
                markers: newCasesMarkers,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle2);
                },
              ),
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _parisCameraPosition,
                markers: newDeathsMarkers,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle3);
                },
              ),
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _parisCameraPosition,
                markers: allDeathsMarkers,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle);
                },
              ),
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _parisCameraPosition,
                markers: recoveredMarkers,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle);
                },
              ),
            ])));
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
