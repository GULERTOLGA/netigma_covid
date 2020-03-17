import 'editor_properties.dart';
import 'lookup_settings.dart';

//test
class DatasourceProperty {
  final String name;
  final String displayName;
  final bool active;
  final String cacheKey;
  final String datatypeName;
  final String defaultValue;
  final String destinationType;
  final String displayFormat;
  final String entityPath;
  final bool groupable;
  final bool isNullable;
  final int length;
  final String oldName;
  final String ownerName;
  final int precision;
  final bool primaryKey;
  final int scale;
  final String summaryFunction;
  final String typeName;
  final String viewEditorName;
  final LookupSettings lookupSettings;
  final EditorProperties queryEditor;
  final EditorProperties formEditor;

  DatasourceProperty({
    this.active,
    this.cacheKey,
    this.datatypeName,
    this.defaultValue,
    this.destinationType,
    this.displayFormat,
    this.displayName,
    this.entityPath,
    this.groupable,
    this.isNullable,
    this.length,
    this.name,
    this.oldName,
    this.ownerName,
    this.precision,
    this.primaryKey,
    this.scale,
    this.summaryFunction,
    this.typeName,
    this.viewEditorName,
   this.lookupSettings,
    this.formEditor,
    this.queryEditor,
  });

  bool operator ==(o) => o is DatasourceProperty && o.entityPath == entityPath;

  int get hashCode => entityPath.hashCode;

  String toString() => this.entityPath;

  factory DatasourceProperty.fromJson(Map<String, dynamic> json) {

    return new DatasourceProperty(
        active: json["Active"],
        cacheKey: json["CacheKey"],
        datatypeName: json["DatatypeName"],
        defaultValue: json["DefaultValue"],
        destinationType: json["DestinationType"],
        displayFormat: json["DisplayFormat"],
        displayName: json["DisplayName"],
        entityPath: json["EntityPath"],
        queryEditor: EditorProperties.fromJson(json["QueryEditor"]),
        formEditor: EditorProperties.fromJson(json["FormEditor"]),
        groupable: json["Groupable"],
        isNullable: json["IsNullable"],
        length: json["Length"],
        name: json["Name"],
        oldName: json["OldName"],
        ownerName: json["OwnerName"],
        precision: json["Precision"],
        primaryKey: json["PrimaryKey"],
        scale: json["Scale"],
        summaryFunction: json["SummaryFunction"],
        typeName: json["TypeName"],
        viewEditorName: json["ViewEditorName"],
        lookupSettings: LookupSettings.fromJson(json["LookupSettings"]),
       );
  }
}
