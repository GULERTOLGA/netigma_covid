import 'netigma_action.dart';
import 'query.dart';
import 'query_column.dart';

abstract class DatasetBase{
  bool get iSStatistical;
  QueryColumnList getColumns();
  List<DataRow> getRows();
  String getRowFilter(int rowIndex);
}

class QueryResult implements DatasetBase{
  final QueryColumnList columns;
  final List<DataRow> rows;
  final Query query;
  final String primaryKey;
  final int primaryKeyIndex;
  final bool iSStatistical;

  QueryResult(this.query,
      {this.columns, this.rows, this.primaryKey, this.primaryKeyIndex, this.iSStatistical});

  String getRowFilter(int rowIndex) {
    var objectID = this.rows[rowIndex].cells[0].value;
    return "$primaryKey = '$objectID'";
  }

  bool get hasMapAction => this.rows != null && this.rows.length > 0 && this.rows[0].hasMapAction;

  factory QueryResult.fromJson(Map<String, dynamic> json, Query query) {
    var items = json["Rows"].map((i) => DataRow.fromJson(i["Cells"])).toList();
    List<DataRow> drs = new List<DataRow>.from(items);
    return new QueryResult(
      query,
      columns: QueryColumnList.fromJson(json["Columns"]),
      rows: drs,
      primaryKey: json['PrimaryKey'],
      primaryKeyIndex: json['PrimaryKeyIndex'],
      iSStatistical: json['ISStatistical'],
    );
  }

  @override
  QueryColumnList getColumns() {
    return this.columns;
  }

  @override
  List<DataRow> getRows() {
    return this.rows;
  }





}

class DataRow {
  final List<DataCell> cells;

  DataRow({this.cells});

  List<INetigmaAction> get actions => cells
      .where((a) => a.netigmaAction != null)
      .map((c) => c.netigmaAction)
      .toList();


  bool get hasMapAction => actions?.firstWhere((a)=>a.name == "MapGUI", orElse: (){ return null;}) != null;

  String get rowFilter =>  actions?.firstWhere((a)=>a.name == "MapGUI", orElse: (){ return null;})?.getLegacyCriteria();

  factory DataRow.fromJson(List<dynamic> items) {
    List<DataCell> dataRowItems =
        items.map((i) => DataCell.fromJson(i)).toList();

    return new DataRow(cells: dataRowItems); //new DataRow(items: items);
  }

  ActionMap getDefaultMapAction() {
    return  this.actions?.firstWhere((a) => a.name == "MapGUI", orElse: () => null);
  }

  ActionForm getDefaultFormAction() {
    return  this.actions?.firstWhere((a) => a.name == "FormGUI", orElse: () => null);
  }

  List<DataCell> getRowsHasActions(bool hideMapAction)
  {
    var actions = this.cells.where((a)=>a.actionData != null &&
        netigmaActions.containsKey(a.actionData.actionName) ).take(4).toList();
    if(actions != null && actions.length > 0 &&  hideMapAction )
      actions =  actions.where((a)=>a.actionData.actionName !="MapGUI" && a.actionData.actionName != "MobileMapGUI").toList();
    return actions;
  }

  List<DataCell> getRows()
  {
    return this.cells.where((a)=>a.actionData == null).toList();
  }

}

class DataCell {
  final dynamic value;
  final String displayText;
  final ActionData actionData;
  final String columnName;

  INetigmaAction get netigmaAction =>
      actionData != null ? netigmaActions[actionData.actionName]?.build(this) : null;

  DataCell({this.value, this.displayText, this.actionData,this.columnName, });
  factory DataCell.fromJson(Map<String, dynamic> json) {
    return new DataCell(
        value: json["Value"],
        actionData: json.containsKey("ActionData") && json["ActionData"] != null ? ActionData.fromJson(json["ActionData"]): null,
        displayText: json["DisplayText"],
        columnName: json["ColumnName"]);
  }
}

class ActionData {
  final String actionName;
  final String displayName;
  final dynamic parameters;
  ActionData({this.actionName, this.parameters,this.displayName});

  factory ActionData.fromJson(Map<String, dynamic> json) {
    return new ActionData(
      actionName: json["ActionName"],
      parameters: json["Parameters"],
      displayName: json["DisplayName"],
    );
  }
}
