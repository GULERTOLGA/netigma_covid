import 'package:flutter/cupertino.dart';

class NetigmaValidation {
  final bool validationEnabled;
  final bool allowNull;
  final String errorMessage;
  final String invalidRegex;
  final String invalidRegexErrorMessage;
  final String validRegex;
  final String regexErrorMessage;
  final String maxValue;
  final String minValue;
  final String rangeErrorMessage;

  NetigmaValidation(
      {this.validationEnabled,
      this.allowNull,
      this.errorMessage,
      this.invalidRegex,
      this.invalidRegexErrorMessage,
      this.validRegex,
      this.regexErrorMessage,
      this.minValue,
      this.maxValue,
      this.rangeErrorMessage});

  factory NetigmaValidation.fromJson(Map<String, dynamic> json) {
    return json != null
        ? new NetigmaValidation(
            validationEnabled:
                json.containsKey("Enabled") ? json["Enabled"] : false,
            allowNull:
                json.containsKey("AllowNull") ? json["AllowNull"] : false,
            errorMessage:
                json.containsKey("ErrorMessage") ? json["ErrorMessage"] : "",
            invalidRegex:
                json.containsKey("InvalidRegex") ? json["InvalidRegex"] : "",
            invalidRegexErrorMessage:
                json.containsKey("InvalidRegexErrorMessage")
                    ? json["InvalidRegexErrorMessage"]
                    : "",
            validRegex:
                json.containsKey("ValidRegex") ? json["ValidRegex"] : "",
            regexErrorMessage: json.containsKey("RegexErrorMessage")
                ? json["RegexErrorMessage"]
                : "",
            maxValue: json.containsKey("maxValue") ? json["maxValue"] : "",
            minValue: json.containsKey("minValue") ? json["minValue"] : "",
            rangeErrorMessage: json.containsKey("RangeErrorMessage")
                ? json["RangeErrorMessage"]
                : "",
          )
        : new NetigmaValidation();
  }

  String validate(BuildContext context, String text) {
    if (validationEnabled != null && validationEnabled) {
      if (!allowNull && (text == "" || text == null))
        return errorMessage != null && errorMessage.isNotEmpty
            ? errorMessage
            :"invalid";
      if (validRegex != null && validRegex.isNotEmpty) {
        var regex = new RegExp(validRegex);
        if (!regex.hasMatch(text)) {
          return invalidRegexErrorMessage;
        } else
          return null;
      } else
        return null;
    } else
      return null;
  }
}
