import 'dart:async';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  ClusterManager _manager;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = Set();

  final CameraPosition _parisCameraPosition =
  CameraPosition(target: LatLng(36.856613, 45.352222), zoom: 3.0);

  List<ClusterItem<Place>> items = [
    for (int i = 0; i < 40; i++)
      ClusterItem(LatLng(48.848200 + i * 0.001, 2.319124 + i * 0.001),
          item: Place(name: 'Place $i')),
    for (int i = 0; i < 40; i++)
      ClusterItem(LatLng(48.858265 - i * 0.001, 2.350107 + i * 0.001),
          item: Place(name: 'Restaurant $i', isClosed: i % 2 == 0)),
    for (int i = 0; i < 40; i++)
      ClusterItem(LatLng(48.858265 + i * 0.01, 2.350107 - i * 0.01),
          item: Place(name: 'Bar $i')),
    for (int i = 0; i < 40; i++)
      ClusterItem(LatLng(48.858265 - i * 0.1, 2.350107 - i * 0.01),
          item: Place(name: 'Hotel $i')),
    for (int i = 0; i < 40; i++)
      ClusterItem(LatLng(48.858265 + i * 0.1, 2.350107 + i * 0.1)),
    for (int i = 0; i < 40; i++)
      ClusterItem(LatLng(48.858265 + i * 1, 2.350107 + i * 1)),
  ];
  String _mapStyle;
  @override
  void initState() {
    _manager = _initClusterManager();
    super.initState();

    rootBundle.loadString('assets/style.txt').then((string) {
      _mapStyle = string;
    });
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
            new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
          ].toSet(),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _manager.setMapController(controller);
            controller.setMapStyle(_mapStyle);
          },
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap),

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
    final Paint paint1 = Paint()..color = Colors.orange;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
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