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

library era_geojson.src.geometry.multi_point;

import 'base.dart';
import 'point.dart';

/// For type [MultiPoint], the coordinates member must be an array of positions.
class MultiPoint extends Geometry<List<Point>> {
  MultiPoint(List<Point> points) : super(points, GeometryType.MULTI_POINT);

  MultiPoint.fromArray(List<List<num>> data)
      : this(PointListGeometry.parseList(data));

  MultiPoint.fromJson(Map<String, dynamic> json)
      : this(PointListGeometry.parseJson(json));

  @override
  int get hashCode {
    return Geometry.EQUALITY.hash(coordinates) ^ type.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MultiPoint &&
        Geometry.EQUALITY.equals(coordinates, other.coordinates) &&
        type == other.type;
  }

  @override
  String toString() => 'MultiPoint{coordinates: $coordinates}';
}
