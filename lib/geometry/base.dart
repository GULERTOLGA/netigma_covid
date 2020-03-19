// Copyright (C) 2016  Andrea Cantafio

//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

library era_geojson.src.geometry.base;

import 'package:collection/collection.dart';

import 'latlng.dart';
import 'geometry_collection.dart';
import 'geometry_type.dart';
import 'line_string.dart';
import 'multi_line_string.dart';
import 'multi_point.dart';
import 'multi_polygon.dart';
import 'point.dart';
import 'polygon.dart';

export 'geometry_collection.dart';
export 'geometry_type.dart';
export 'line_string.dart';
export 'multi_line_string.dart';
export 'multi_point.dart';
export 'multi_polygon.dart';
export 'point.dart';
export 'polygon.dart';

dynamic _getCoordinates(Map<String, dynamic> json) {
  if (null == json) {
    throw new ArgumentError.notNull('json');
  }
  if (!json.containsKey('coordinates')) {
    throw new ArgumentError('Missing coordinates.');
  }
  final coordinates = json['coordinates'];
  if (null == coordinates) {
    throw new ArgumentError.notNull('coordinates');
  }
  return coordinates;
}

typedef T GeometryJsonFactory<T extends Geometry>(Map<String, dynamic> json);

/// A position is the fundamental geometry construct.
///
/// The [coordinates] member of a [Geometry] object is composed of one position
/// (in the case of a [Point]), an array of positions
/// ([LineString] or [MultiPoint] geometries), an array of arrays of positions
/// ([Polygons], [MultiLineStrings]), or a multidimensional array of positions
/// ([MultiPolygon]).
///
/// A position is represented by an array of numbers. There must be at least two
/// elements, and may be more. The order of elements must follow x, y, z order
/// (easting, northing, altitude for coordinates in a projected coordinate
/// reference system, or longitude, latitude, altitude for coordinates in a
/// geographic coordinate reference system).
/// Any number of additional elements are allowed -- interpretation and meaning
/// of additional elements is beyond the scope of this specification.
/// (Currently only x, y position are supported)
abstract class Geometry<T> {
  static const Equality EQUALITY = const ListEquality();
  final T coordinates;

  final GeometryType type;

  Geometry(this.coordinates, this.type);

  factory Geometry.fromJson(Map<String, dynamic> json) {

    if(json == null)
      return null;

    if (!json.containsKey('type')) {
      throw new ArgumentError('Missing type key');
    }
    final type = json['type'];
    if (!_GeometryFactories.FACTORIES.containsKey(type)) {
      throw new ArgumentError('Unknown geometry type');
    }
    return _GeometryFactories.FACTORIES[type](json);
  }

  @override
  int get hashCode;

  @override
  bool operator ==(Object other);

  static getCoordinates(Map<String, dynamic> json) => _getCoordinates(json);
}

abstract class LineStringListGeometry {
  static List<LineString> parseJson(Map<String, dynamic> json) {
    final lines = Geometry.getCoordinates(json);
    if (lines is! List) {
      throw new ArgumentError('Invalid lines: List expected.');
    }
    return parseList(lines);
  }



  static List<LineString> parseList(List<dynamic> data) {
    return data.map((line) {
      if (line is! List) {
        throw new ArgumentError('Invalid line: $line. List expected.');
      }
      return new LineString.fromArray(line);
    }).toList(growable: false);
  }
}

abstract class PointListGeometry {
  static List<Point> parseJson(Map<String, dynamic> json) {
    final points = Geometry.getCoordinates(json);
    if (points is! List) {
      throw new ArgumentError('Invalid coordinates: List<List> expected.');
    }
    return parseList(points);
  }

  static List<Point> parseList(List<dynamic> data) =>
      data.map((point) {
        if (point is! List) {
          throw new ArgumentError('Invalid point: $point. List<num> expected.');
        }
        return new Point(new Coordinate(point[1], point[0]));
      }).toList(growable: false);
}

class _GeometryFactories {
  static const Map<String, GeometryJsonFactory> FACTORIES =
  const <String, GeometryJsonFactory>{
    'GeometryCollection': _buildGeometryCollection,
    'LineString': _buildLineString,
    'MultiLineString': _buildMultiLineString,
    'MultiPoint': _buildMultiPoint,
    'Point': _buildPoint,
    'Polygon': _buildPolygon,
    'MultiPolygon': _buildMultiPolygon
  };

  static GeometryCollection _buildGeometryCollection(
      Map<String, dynamic> json) =>
      new GeometryCollection.fromJson(json);

  static LineString _buildLineString(Map<String, dynamic> json) =>
      new LineString.fromJson(json);

  static MultiLineString _buildMultiLineString(Map<String, dynamic> json) =>
      new MultiLineString.fromJson(json);

  static MultiPoint _buildMultiPoint(Map<String, dynamic> json) =>
      new MultiPoint.fromJson(json);

  static MultiPolygon _buildMultiPolygon(Map<String, dynamic> json) =>
      new MultiPolygon.fromJson(json);

  static Point _buildPoint(Map<String, dynamic> json) =>
      new Point.fromJson(json);

  static Polygon _buildPolygon(Map<String, dynamic> json) =>
      new Polygon.fromJson(json);
}
