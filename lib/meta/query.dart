
import 'datasource_property.dart';
import 'gridview_options.dart';

class Query {
  final String name;
  final String displayName;
  final List<DatasourceProperty> criterias;
  final String action;
  final String actionData;
  final GridViewOptions gridViewOptions;
  final String dataSource;
  final dynamic parameters;
  final String description;
  int rowCount =0;

  Query( {this.name, this.displayName, this.criterias, this.actionData, this.action, this.gridViewOptions, this.dataSource, this.parameters,this.description});


  factory Query.fromJson(Map<String, dynamic> json) {
    var list = json['Fields'] as List;
    List<DatasourceProperty> criteriaList =
        list.map((i) => DatasourceProperty.fromJson(i)).toList();

    return new Query(
      criterias: criteriaList,
      name: json['Name'],
      displayName: json['DisplayName'],
      action: json['Action'],
      actionData: json['ActionData'],
      gridViewOptions: GridViewOptions.fromJson(json['GridViewOptions']),
      dataSource: json["Datasource"],
      description: json["Description"],
      parameters: json.containsKey("Parameters") ? json["Parameters"] : null,

    );
  }
}