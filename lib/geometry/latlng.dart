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

library era_geojson.src.latlng;

class Coordinate {
  num _lat;
  num _lng;

  Coordinate(num lat, num lng) {
    _checkLat(lat);
    _checkLng(lng);

    _lat = lat;
    _lng = lng;
  }

  @override
  int get hashCode {
    return _lat.hashCode ^ _lng.hashCode;
  }

  num get latitude => _lat;

  set latitude(num lat) {
    _checkLat(lat);
    _lat = lat;
  }

  num get longitude => _lng;

  set longitude(num lng) {
    _checkLng(lng);
    _lng = lng;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Coordinate &&
        this._lat == other._lat &&
        this._lng == other._lng;
  }

  @override
  String toString() => 'LatLng{_lat: $_lat, _lng: $_lng}';

  String toWKT()=>'POINT($_lng $_lat)';

  static void _checkLat(num lat) {
    if (lat < -90 || lat > 90) {
      throw new ArgumentError(
          'Invalid lat: $lat. Value should be between -90 (inclusive) and 90 (inclusive)');
    }
  }

  static void _checkLng(num lng) {
    if (lng < -180 || lng > 180) {
      throw new ArgumentError(
          'Invalid lng: $lng. Value should be between -180 (inclusive) and 180 (inclusive)');
    }
  }
}
