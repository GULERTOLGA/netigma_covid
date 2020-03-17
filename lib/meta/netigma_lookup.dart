class LookupItem {
  final String value;
  final String text;

  LookupItem({this.value, this.text});

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    return new LookupItem(
      value: json["Value"].toString(),
      text: json["Text"].toString(),
    );
  }
}

class LookupItemList {
  List<LookupItem> items;
  LookupItemList({this.items});

  factory LookupItemList.fromJson(dynamic json) {
    var list = json as List;
    List<LookupItem> lookupItemsList =
        list != null ? list.map((i) => LookupItem.fromJson(i)).toList() : null;
    return new LookupItemList(items: lookupItemsList);
  }
}