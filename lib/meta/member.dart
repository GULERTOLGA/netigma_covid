import 'package:google_maps_flutter/google_maps_flutter.dart';

class NetigmaMember {
  final int objectid;
  final String title;
  final String endpoint;
  final double distance;
  final String imageUrl;
  final String netgisUrl;
  final String backgroundUrl;
  final LatLngBounds bounds;
  final String memberKey;
  final String theme;
  final String defaultWorkSpace;

  String get bboxString => bounds != null
      ? "${bounds.southwest.longitude};${bounds.southwest.latitude};${bounds.northeast.longitude};${bounds.northeast.latitude}"
      : null;

  NetigmaMember(
      {this.memberKey,
      this.objectid,
      this.title,
      this.endpoint,
      this.distance,
      this.netgisUrl,
      this.imageUrl,
      this.backgroundUrl,
      this.bounds, this.theme,this.defaultWorkSpace,});

  factory NetigmaMember.fromJSON(Map<String, dynamic> json) {
    LatLngBounds bnds;
    if (json.containsKey("bbox") && json["bbox"] != null) {
      var lLon = json["bbox"][0];
      var lLat = json["bbox"][1];
      var uLon = json["bbox"][2];
      var uLat = json["bbox"][3];
      bnds = new LatLngBounds(
          northeast: new LatLng(uLat, uLon), southwest: new LatLng(lLat, lLon));
    }

    return new NetigmaMember(
        objectid: json["objectid"],
        title: json["title"],
        endpoint: json["endpoint"],
        distance: json["distance"],
        imageUrl: json["imageurl"],
        memberKey: json["memberKey"],
        backgroundUrl: json["backgroundurl"],
        netgisUrl: json["netgisurl"],
        theme: json["theme"],
        defaultWorkSpace:json["defaultWorkSpace"] ,
        bounds: bnds);
  }

  getBounds(json) {}
}
