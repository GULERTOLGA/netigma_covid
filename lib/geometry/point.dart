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

library era_geojson.src.geometry.point;

import 'latlng.dart';
import 'base.dart';

String _invalidPositionLength(String name, data) =>
    'Invalid $name: $data. At least 2 items expected.';

Coordinate _parseArray(List<num> data) {
  if (null == data) {
    throw new ArgumentError.notNull('data');
  }
  if (2 > data.length) {
    throw new ArgumentError(_invalidPositionLength('data', data));
  }
  return new Coordinate(data[1], data[0]);
}

Coordinate _parseJson(Map<String, dynamic> json) {
  final coordinates = Geometry.getCoordinates(json);
  if (coordinates is! List) {
    throw new ArgumentError('Invalid coordinates: List expected');
  }
  if (2 > coordinates.length) {
    throw new ArgumentError(_invalidPositionLength('coordinates', coordinates));
  }
  return new Coordinate(coordinates[1], coordinates[0]);
}

/// For type [Point], the [coordinates] member is a single position.
class Point extends Geometry<Coordinate> {
  Point(Coordinate coordinates) : super(coordinates, GeometryType.POINT);

  Point.fromArray(List<num> data) : this(_parseArray(data));

  Point.fromJson(Map<String, dynamic> json) : this(_parseJson(json));

  @override
  int get hashCode {
    return coordinates.hashCode ^ type.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Point &&
        coordinates == other.coordinates &&
        type == other.type;
  }

  @override
  String toString() => 'Point{coordinates: $coordinates}';
}
