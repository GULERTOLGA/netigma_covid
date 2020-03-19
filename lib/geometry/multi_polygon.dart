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

library era_geojson.src.geometry.multi_polygon;

import 'base.dart';

List<Polygon> _parseJson(Map<String, dynamic> json) {
  final polygons = Geometry.getCoordinates(json);
  if (polygons is! List) {
    throw new ArgumentError('Invalid polygons: $polygons. List expected.');
  }
  return _parseList(polygons);
}

List<Polygon> _parseList(List<List<List<List<num>>>> data) {
  return data.map((polygon) {
    if (polygon is! List) {
      throw new ArgumentError('Invalid polygon: $polygon. List expected.');
    }
    return new Polygon.fromArray(polygon);
  }).toList(growable: false);
}

/// For type [MultiPolygon], the [coordinates] member must be an array of
/// [Polygon] coordinate arrays.
class MultiPolygon extends Geometry<List<Polygon>> {
  MultiPolygon(List<Polygon> polygons)
      : super(polygons, GeometryType.MULTI_POLYGON);

  MultiPolygon.fromArray(List<List<List<List<num>>>> data)
      : this(_parseList(data));

  MultiPolygon.fromJson(Map<String, dynamic> json) : this(_parseJson(json));

  @override
  int get hashCode => Geometry.EQUALITY.hash(coordinates) ^ type.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MultiPolygon &&
        Geometry.EQUALITY.equals(coordinates, other.coordinates) &&
        type == other.type;
  }

  @override
  String toString() => 'MultiPolygon{coordinates: $coordinates}';
}
