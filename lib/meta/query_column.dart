
class QueryColumn {
  final String name;
  final String displayName;
  final String actionName;
  final dynamic actionData;
  final String dataTypeName;
  final String displayFormat;
  final int columnIndex;
  final String path;


  QueryColumn(this.columnIndex,
      {this.name,
      this.displayName,
      this.actionName,
      this.actionData,
      this.dataTypeName,
      this.displayFormat, this.path});

  factory QueryColumn.fromJson(Map<String, dynamic> json, int columnIndex) {
    var retVal = new QueryColumn(
      columnIndex,
      name: json["Name"],
      displayName: json["DisplayName"],
      actionName: json["Action"],
      actionData: json["ActionData"],
      dataTypeName: json["DataTypeName"],
      displayFormat: json["DisplayFormat"],
      path:json["Path"]
    );
    return retVal;
  }
}

class QueryColumnList {
  final List<QueryColumn> items;

  QueryColumnList({this.items});



  factory QueryColumnList.fromJson(List<dynamic> parsedJson) {
    List<QueryColumn> items = parsedJson
        .asMap()
        .map((i, element) => MapEntry(i, QueryColumn.fromJson(element, i)))
        .values
        .toList();

    return new QueryColumnList(
      items: items,
    );
  }
}
