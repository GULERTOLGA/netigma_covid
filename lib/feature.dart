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

library era_geojson.src.feature;

import 'geometry/latlng.dart';
import 'meta/query_column.dart';
import 'meta/query_result.dart';


import 'geometry/geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;


class Feature {

  Coordinate centroid;

  Coordinate interiorPoint;

  Geometry geometry;

  Map<String, dynamic> properties;

  Feature(this.geometry, this.properties, this.centroid, );

  factory Feature.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('geometry')) {
      throw new ArgumentError('Missing geometry key.');
    }
    final geometry = json['geometry'];

    if (!json.containsKey('properties')) {
      throw new ArgumentError('Missing properties key.');
    }
    final properties = json['properties'];
    if (properties is! Map<String, dynamic>) {
      throw new ArgumentError(
          'Invalid properties: $properties. Map<String, dynamic> expected.');
    }

    Coordinate centroid;
    if(json.containsKey("centroid") && json["centroid"] != null)
      {
        var lon =json["centroid"][0];
        var lat =json["centroid"][1];

        centroid = new Coordinate(lat, lon);
      }

    Feature retVal = new Feature(new Geometry.fromJson(geometry), properties, centroid);

    if(json.containsKey("interiorPoint") && json["interiorPoint"] != null)
    {
      var lon =json["interiorPoint"][0];
      var lat =json["interiorPoint"][1];

      retVal.interiorPoint = new Coordinate(lat, lon);
    }
    return retVal;
  }

  @override
  int get hashCode {
    return geometry.hashCode ^ properties.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Feature &&
        this.geometry == other.geometry &&
        this.properties == other.properties;
  }

  @override
  String toString() => 'Feature{geometry: $geometry, properties: $properties}';
}

class FeatureCollection implements DatasetBase{
  final List<Feature> features;
  final QueryColumnList columns ;
  final google.LatLngBounds bounds;
  final List<DataRow> rows;
  final String primaryKey;

  FeatureCollection(this.features, this.columns, this.bounds, this.rows, this.primaryKey);

  factory FeatureCollection.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('features')) {
      throw new ArgumentError('Missing features key.');
    }

    var items = json["rows"].map((i) => DataRow.fromJson(i["Cells"])).toList();
    List<DataRow> drs = new List<DataRow>.from(items);

    google.LatLngBounds bounds;

    if(json.containsKey("bbox") && json["bbox"] != null)
      {
        var lLon = json["bbox"][0];
        var lLat = json["bbox"][1];
        var uLon = json["bbox"][2];
        var uLat = json["bbox"][3];

        bounds = new google.LatLngBounds(northeast: new google.LatLng(uLat, uLon), southwest:new google.LatLng(lLat, lLon));
      }

    final features = json['features'];
    if (features is! List) {
      throw new ArgumentError('Invalid features: $features. List expected.');
    }
    return new FeatureCollection(features.map<Feature>((feature) {
      if (feature is! Map<String, dynamic>) {
        throw new ArgumentError(
            'Invalid feature: $feature. Map<String, dynamic> expected.');
      }
      return new Feature.fromJson(feature);
    }).toList(growable: false), json.containsKey("columns") ? new QueryColumnList.fromJson(json["columns"]): null,bounds
    , drs,json["PrimaryKey"].toString());
  }

  @override
  String toString() => 'FeatureCollection{features: $features}';

  @override
  QueryColumnList getColumns() {
    // TODO: implement getColumns
    return this.columns;
  }

  @override
  String getRowFilter(int rowIndex) {
    var objectID = this.rows[rowIndex].cells[0].value;
    return "$primaryKey = '$objectID'";
  }

  @override
  List<DataRow> getRows() {
    // TODO: implement getRows
    return this.rows;
  }

  @override
  // TODO: implement iSStatistical
  bool get iSStatistical => false;
}