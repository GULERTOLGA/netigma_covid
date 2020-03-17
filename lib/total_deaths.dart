import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TotalDeaths extends StatefulWidget {
  final String sessionid;

  const TotalDeaths({Key key, this.sessionid}) : super(key: key);

  @override
  _TotalDeathsState createState() => _TotalDeathsState();
}

class _TotalDeathsState extends State<TotalDeaths> {


  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    getCases(widget.sessionid);
  }

 List<Item> items = [];
  bool loading = true;

  void getCases(sessiionid) async
  {
    //http://ssltest.netcad.com.tr/covid/gisapi/query/Template?TemplateName=corona_totals&SessionID=7f9da62287d841708fe8a05d6c082a7d&enableCache=true
    final response = await http
        .get("http://ssltest.netcad.com.tr/covid/gisapi/query/query?queryName=geocases.Sorgusu&SessionID=${sessiionid}&enableCache=true");
    var t = response.body;
    var tt = json.decode(response.body);

    var c = 1;
    for(int i = 0; i < tt["Rows"].length; i++)
      {
        var g = tt["Rows"][i];
        var n = g["Cells"][4]["DisplayText"];
        var v = g["Cells"][5]["DisplayText"];
        var t = 11;

        items.add(new Item(n, v));

      }
    setState(() {
      loading = false;

    });


  }

  @override
  Widget build(BuildContext context) {
    return loading ? Container():
    ListView.separated( separatorBuilder: (BuildContext context, int index) =>
        Divider(
          height: 0,
        ),
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(items[index].a),
        trailing: Text(items[index].b),

      );
    });
  }
}

class Item
{
  final String a;
  final String b;

  Item(this.a, this.b);
}