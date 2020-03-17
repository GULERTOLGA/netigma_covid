import 'package:google_maps_flutter/google_maps_flutter.dart';

class QueryInfo {
  final String queryName;
  final String criteria;
  final String filter;

  QueryInfo({this.queryName, this.criteria, this.filter});

  factory QueryInfo.fromCoordinates(
      LatLngBounds coordinates, String queryName, String filter) {
    var lat2 = coordinates.northeast.latitude.toString();
    var lon2 = coordinates.northeast.longitude.toString();

    var lat1 = coordinates.southwest.latitude.toString();
    var lon1 = coordinates.southwest.longitude.toString();

    String template = '''
        <Intersects><PropertyName>GEOYOL.poly</PropertyName>
        <gml:Polygon srsName="EPSG:32767" xmlns:gml="http://www.opengis.net/gml"><outerBoundaryIs>
        <LinearRing>
        <coordinates decimal="." cs="," ts=" ">
        $lat1,$lon1 $lat1,$lon2 $lat2,$lon2 $lat2,$lon1 $lat1,$lon1</coordinates></LinearRing>
        </outerBoundaryIs>
        </gml:Polygon>
        </Intersects>
        ''';
    return new QueryInfo(
        queryName: queryName, criteria: template, filter: filter);
  }
}


