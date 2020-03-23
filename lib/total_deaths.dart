import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:netigma_covid/utils.dart';


class TotalDeaths extends StatefulWidget {
  final String sessionid;

  const TotalDeaths({Key key, this.sessionid}) : super(key: key);

  @override
  _TotalDeathsState createState() => _TotalDeathsState();
}

class _TotalDeathsState extends State<TotalDeaths> with AutomaticKeepAliveClientMixin<TotalDeaths>{


  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    getCases(widget.sessionid);
  }

  List<Item> allCasesItems = [];
  List<Item> newCasesItems = [];
  List<Item> allDeathsItems = [];
  List<Item> newDeathsItems = [];
  List<Item> recoveredItems = [];
  bool loading = true;

  void getCases(sessiionid) async
  {
    final response = await http
        .get("https://covid19.netigma.io/covid/gisapi/query/query?queryName=geocases.Sorgusu&SessionID=${sessiionid}&enableCache=true");
    var t = response.body;
    var tt = json.decode(response.body);
    var c = 1;
    for(int i = 0; i < tt["Rows"].length; i++)
      {
        var g = tt["Rows"][i];
        var country = g["Cells"][4]["Value"];
        var allCases = g["Cells"][5]["Value"];
        var newCases = g["Cells"][6]["Value"];
        var allDeaths = g["Cells"][7]["Value"];
        var recovereds = g["Cells"][11]["Value"];
        var newDeaths = g["Cells"][8]["Value"];

        var t = 11;
        allCasesItems.add(new Item(country, allCases.round()));
        newCasesItems.add(new Item(country, newCases.round()));
        allDeathsItems.add(new Item(country, allDeaths.round()));
        recoveredItems.add(new Item(country, recovereds.round()));
        newDeathsItems.add(new Item(country, newDeaths.round()));
      }

    newCasesItems.sort((a, b) => b.totalCases.compareTo(a.totalCases));
    allDeathsItems.sort((a, b) => b.totalCases.compareTo(a.totalCases));
    recoveredItems.sort((a, b) => b.totalCases.compareTo(a.totalCases));
    recoveredItems.sort((a, b) => b.totalCases.compareTo(a.totalCases));

    newDeathsItems = newDeathsItems.where((a)=>a.totalCases > 0).toList();

    setState(() {
      loading = false;
    });


  }
  final formatter = new NumberFormat("#,###");


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: new TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: new Text("All Cases"),
              ),
              Tab(
                icon: new Text("New Cases"),
              ),
              Tab(
                icon: new Text("New Deaths"),
              ),
              Tab(
                icon: new Text("All Deaths"),
              ),
              Tab(
                icon: new Text("Recovered"),
              )
            ],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
        ),

        body: TabBarView(
            children: [
              loading ? Center( child:CircularProgressIndicator()):getListView(allCasesItems),
              loading ? Center( child:CircularProgressIndicator()):getListView(newCasesItems),
              loading ? Center( child:CircularProgressIndicator()):getListView(newDeathsItems),
              loading ? Center( child:CircularProgressIndicator()):getListView(allDeathsItems),
              loading ? Center( child:CircularProgressIndicator()):getListView(recoveredItems),
            ])
      ),
    ) ;



  }

  Widget getListView(allCasesItems)
  {
   return  ListView.separated( separatorBuilder: (BuildContext context, int index) =>
        Divider(
          height: 0,
        ),
        itemCount: allCasesItems.length,
        itemBuilder: (BuildContext context, int index) {
          var image = flags[allCasesItems[index].country];
          var title = allCasesItems[index].country;
          var val = allCasesItems[index].totalCases;
          return ListTile(

            onTap: (){
              addFavorites(title);
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: image !=null ? image :  CircleAvatar(child: Text(allCasesItems[index].country[0]),),
            ),
            subtitle: Text(title),
            title:  Text(val != null ? formatter.format(val): val),
            trailing: Icon(Icons.add_circle_outline)

          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Item
{
  final String country;
  final int totalCases;

  Item(this.country, this.totalCases);
}