import 'netigma_validation.dart';

class EditorProperties
{
  final String typeName;
  final bool readonly;
  final String defaultValue;
  final String defaultText;
  final NetigmaValidation validator;
  final int maxLength;

  EditorProperties( {this.maxLength,this.typeName, this.readonly, this.defaultValue, this.defaultText, this.validator});

  factory EditorProperties.fromJson(Map<String, dynamic> json){
    return new EditorProperties(
      typeName : json["TypeName"],
      readonly : json["Readonly"],
      defaultValue : json["DefaultValue"],
      defaultText : json["DefaultText"],
      maxLength : json["MaxLength"],
      validator : NetigmaValidation.fromJson(json["Validation"]),
    );
  }
}