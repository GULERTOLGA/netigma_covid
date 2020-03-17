class GridViewOptions {
  final String detailQuery;

  final String detailReportName;

  GridViewOptions({this.detailQuery, this.detailReportName});


  factory GridViewOptions.fromJson(Map<String, dynamic> json) {

    return new GridViewOptions(
      detailQuery:json["DetailQuery"],
      detailReportName:json["DetailReportName"],
    );

  }


}
