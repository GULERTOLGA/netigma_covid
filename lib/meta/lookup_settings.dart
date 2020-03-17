class LookupSettings {
  final String table;
  final String displayColumnName;
  final String valueColumnName;
  final bool checkRelationForm;
  final bool checkRelationQuery;

  LookupSettings({this.table, this.displayColumnName, this.valueColumnName, this.checkRelationForm, this.checkRelationQuery});

  factory LookupSettings.fromJson(Map<String, dynamic> json){
    return new LookupSettings(
      table : json["Table"],
      displayColumnName : json["DisplayColumnName"],
      valueColumnName : json["ValueColumnName"],
      checkRelationForm : json["CheckRelationForm"],
      checkRelationQuery : json["CheckRelationQuery"],
    );
  }

}