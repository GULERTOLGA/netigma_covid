
library era_geojson.src.geometry.line_string;

import 'base.dart';
import 'point.dart';

/// For type [LineString], the [coordinates] member must be a [List] of two or
/// more positions.
class LineString extends Geometry<List<Point>> {
  LineString(List<Point> points) : super(points, GeometryType.LINE_STRING);

  LineString.fromArray(List<dynamic> data)
      : super(PointListGeometry.parseList(data), GeometryType.LINE_STRING);

  LineString.fromJson(Map<String, dynamic> json)
      : super(PointListGeometry.parseJson(json), GeometryType.LINE_STRING);

  @override
  int get hashCode => Geometry.EQUALITY.hash(coordinates) ^ type.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is LineString &&
        Geometry.EQUALITY.equals(coordinates, other.coordinates) &&
        type == other.type;
  }

  @override
  String toString() => 'LineString{coordinates: $coordinates}';
}
