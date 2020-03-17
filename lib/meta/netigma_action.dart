import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'query.dart';
import 'query_result.dart' as ntg;


abstract class INetigmaAction {
  Future<dynamic> onTap(BuildContext context, Query currentQuery);
  IconData get icon;
  String get displayName;
  String get name;
  String getLegacyCriteria();
}

abstract class NetigmaActionBase {
  final ntg.DataCell dataCell;
  NetigmaActionBase(this.dataCell);
}

abstract class ActionBuilder {
  INetigmaAction build(ntg.DataCell dataCell);
}

class FormActionBuilder implements ActionBuilder {
  @override
  INetigmaAction build(ntg.DataCell dataCell) {
    return new ActionForm(dataCell);
  }
}

class ParametricQueryActionBuilder implements ActionBuilder {
  @override
  INetigmaAction build(ntg.DataCell dataCell) {
    return new ActionParametricQuery(dataCell);
  }
}

class MapActionBuilder implements ActionBuilder {
  @override
  INetigmaAction build(ntg.DataCell dataCell) {
    return new ActionMap(dataCell);
  }
}

class ActionFileAddBuilder implements ActionBuilder {
  @override
  INetigmaAction build(ntg.DataCell dataCell) {
    return new ActionFileAdd(dataCell);
  }
}

class ActionWebLinkBuilder implements ActionBuilder {
  @override
  INetigmaAction build(ntg.DataCell dataCell) {
    return new ActionWebLink(dataCell);
  }
}

var netigmaActions = <String, ActionBuilder>{
  "FormGUI": new FormActionBuilder(),
  "ParametricQuery": new ParametricQueryActionBuilder(),
  "MapGUI": new MapActionBuilder(),
  "MobileMapGUI": new MapActionBuilder(),
  "FileAddGUI": new ActionFileAddBuilder(),
  "WebLink": new ActionWebLinkBuilder(),
};

class ActionParametricQuery extends NetigmaActionBase
    implements INetigmaAction {
  ActionParametricQuery(dataCell) : super(dataCell);

  @override
  String getLegacyCriteria() {
    return dataCell.actionData.parameters["criteria"];
  }

  @override
  Future<dynamic> onTap(BuildContext context, Query currentQuery) async {

  }

  @override
  String get displayName => dataCell.actionData.displayName != null
      ? dataCell.actionData.displayName
      : "Detaylar";

  @override
  IconData get icon => Icons.search;

  @override
  String get name => "FormGUI";
}

class ActionForm extends NetigmaActionBase implements INetigmaAction {
  @override
  String getLegacyCriteria() {
    return null;
  }

  ActionForm(dataCell) : super(dataCell);
  @override
  Future<dynamic> onTap(BuildContext context, Query currentQuery) async{

  }

  @override
  String get displayName => dataCell.actionData.displayName != null
      ? dataCell.actionData.displayName
      : "Detaylar";

  @override
  IconData get icon => Icons.more_horiz;

  @override
  String get name => "FormGUI";
}

class ActionMap extends NetigmaActionBase implements INetigmaAction {
  ActionMap(dataCell) : super(dataCell);

  @override
  String getLegacyCriteria() {
    return dataCell.actionData.parameters["criteria"];
  }

  String getWorkspace() {
    var workspace = dataCell.actionData.parameters["workspace"];
    return workspace;
  }

  String getQueryName() {
    var queryName = dataCell.actionData.parameters["queryName"];
    return queryName;
  }

  @override
  Future<dynamic> onTap(BuildContext context, Query currentQuery) async{
    var criteria = dataCell.actionData.parameters["criteria"];
    var workspace = dataCell.actionData.parameters["workspace"];
    if (criteria != null) {
      var inQuery = currentQuery;
      if (dataCell.actionData.parameters["queryName"] != null)
        inQuery = new Query(
            name: dataCell.actionData.parameters["queryName"], displayName: "");

    }
  }

  @override
  String get displayName => dataCell.actionData.displayName != null
      ? dataCell.actionData.displayName
      : "Harita";

  @override
  IconData get icon => Icons.map;

  @override
  String get name => "MapGUI";
}

class ActionFileAdd extends NetigmaActionBase implements INetigmaAction {
  ActionFileAdd(dataCell) : super(dataCell);

  @override
  String get displayName => dataCell.actionData.displayName != null
      ? dataCell.actionData.displayName
      : "Resim Ekle";

  @override
  String getLegacyCriteria() {
    return null;
  }

  @override
  IconData get icon => Icons.attach_file;

  @override
  String get name => "FileAddGUI";

  @override
  Future<dynamic> onTap(BuildContext context, Query currentQuery) async{
    var objectName = dataCell.actionData.parameters["table"];
    var objectID = dataCell.actionData.parameters["objectid"];


  }
}

class ActionWebLink extends NetigmaActionBase implements INetigmaAction {
  ActionWebLink(ntg.DataCell dataCell) : super(dataCell);

  @override
  String get displayName => dataCell.actionData.displayName != null
      ? dataCell.actionData.displayName
      : "Web";

  @override
  String getLegacyCriteria() {
    return null;
  }

  @override
  IconData get icon => Icons.link;

  @override
  String get name => "WebLink";

  @override
  Future<dynamic> onTap(BuildContext context, Query currentQuery)  async{
    var url = dataCell.actionData.parameters["url"];

  }
}
