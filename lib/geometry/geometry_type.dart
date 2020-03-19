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

library era_geojson.geometry_type;

const Map<String, GeometryType> _GEOMETRY_TYPES = const <String, GeometryType>{
  'GeometryCollection': GeometryType.GEOMETRY_COLLECTION,
  'LineString': GeometryType.LINE_STRING,
  'MultiLineString': GeometryType.MULTI_LINE_STRING,
  'MultiPoint': GeometryType.MULTI_POINT,
  'Point': GeometryType.POINT,
  'Polygon': GeometryType.POLYGON,
  'MultiPolygon': GeometryType.MULTI_POLYGON
};

GeometryType geometryType(String type) {
  if (null == type) {
    throw new ArgumentError.notNull('type');
  }
  if (!_GEOMETRY_TYPES.containsKey(type)) {
    throw new ArgumentError('Invalid GeometryType: $type');
  }
  return _GEOMETRY_TYPES[type];
}

enum GeometryType {
  GEOMETRY_COLLECTION,
  LINE_STRING,
  MULTI_LINE_STRING,
  MULTI_POINT,
  POINT,
  POLYGON,
  MULTI_POLYGON
}
