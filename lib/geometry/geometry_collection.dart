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

library era_geojson.src.geometry.geometry_collection;

import 'base.dart';

class GeometryCollection extends Geometry<List<Geometry>> {
  GeometryCollection(List<Geometry> geometries)
      : super(geometries, GeometryType.GEOMETRY_COLLECTION);

  factory GeometryCollection.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('geometries')) {
      throw new ArgumentError('Missing geometries key');
    }
    final geometries = json['geometries'];
    if (geometries is! List) {
      throw new ArgumentError('Invalid geometries: $geometries. List expected');
    }
    return new GeometryCollection(geometries.map((geometry) {
      if (geometry is! Map<String, dynamic>) {
        throw new ArgumentError(
            'Invalid geometry: $geometry. Map<String, dynamic> expected.');
      }
      return new Geometry.fromJson(geometry);
    }).toList(growable: false));
  }

  @override
  String toString() => 'GeometryCollection{coordinates: $coordinates}';


}
