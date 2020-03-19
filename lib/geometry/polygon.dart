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

library era_geojson.src.geometry.polygon;

import 'base.dart';

/// For type [Polygon], the [coordinates] member must be an array of
/// [LinearRing] coordinate arrays.
/// For Polygons with multiple rings, the first must be the exterior ring and
/// any others must be interior rings or holes.
class Polygon extends Geometry<List<LineString>> {
  Polygon(List<LineString> lines) : super(lines, GeometryType.POLYGON);

  Polygon.fromArray(List<List<List<num>>> lines)
      : this(LineStringListGeometry.parseList(lines));

  Polygon.fromJson(Map<String, dynamic> json)
      : this(LineStringListGeometry.parseJson(json));

  @override
  int get hashCode => Geometry.EQUALITY.hash(coordinates) ^ type.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Polygon &&
        Geometry.EQUALITY.equals(coordinates, other.coordinates) &&
        type == other.type;
  }

  @override
  String toString() => 'Polygon{coordinates: $coordinates}';


}
