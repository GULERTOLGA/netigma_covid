
class FormAction
{
  final String actionName;
  final String displayName;
  final dynamic parameters;

  FormAction({this.actionName, this.displayName, this.parameters});

  factory FormAction.fromJson(Map<String, dynamic> json) {
    return new FormAction(
      actionName:json["ActionName"],
      displayName:json["DisplayName"],
      parameters:json["Parameters"],
    );
  }
}

