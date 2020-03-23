import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netigma_covid/card_widget.dart';
import 'package:netigma_covid/meta/country_model.dart';
import 'package:netigma_covid/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'meta/query.dart';
import 'meta/query_result.dart';


class FavouritesWidget extends StatefulWidget {
  final String sessionid;

  const FavouritesWidget({Key key, this.sessionid}) : super(key: key);
  @override
  _FavouritesWidgetState createState() => _FavouritesWidgetState();
}

class _FavouritesWidgetState extends State<FavouritesWidget> {

  List<String> favourites =[];

  @override
  void initState() {
    // TODO: implement initState

     getFavorites().then((o){
      setState(() {
            favourites =o;
            if(favourites != null && favourites.length > 0)
              getCases(widget.sessionid);
      });

    });

    super.initState();


  }

  List<CountryModel> countries = [];

  bool _loading = true;

  bool _error = false;

  void getCases(sessiionid) async {

    countries.clear();
    try {

      favourites = await getFavorites();
      String filter = "geocases.ADMIN in ('${favourites.join("','")}')";
      final response = await http
          .get(
          "https://covid19.netigma.io/covid/gisapi/query/query?queryName=geocases.Sorgusu&SessionID=${sessiionid}&filter=$filter&enableCache=true");

      var t = response.body;
      var tt = json.decode(response.body);
      var qr = QueryResult.fromJson(tt, new Query());
      for (int i = 0; i < qr.rows.length; i++) {
        CountryModel cm = new CountryModel(

          name: qr.rows[i].cells
              .firstWhere((a) => a.columnName == "geocases.ADMIN")
              .value,
          total: qr.rows[i].cells
              .firstWhere((a) => a.columnName == "geocases.total")
              .value
              .round(),
          newCases: qr.rows[i].cells
              .firstWhere((a) => a.columnName == "geocases.newcases")
              .value
              .round(),
          totalDeaths: qr.rows[i].cells
              .firstWhere((a) => a.columnName == "geocases.deaths")
              .value
              .round(),
          newDeaths: qr.rows[i].cells
              .firstWhere((a) => a.columnName == "geocases.newdeaths")
              .value
              .round(),
          actives: qr.rows[i].cells
              .firstWhere((a) => a.columnName == "geocases.active")
              .value
              .round(),
          recovered: qr.rows[i].cells
              .firstWhere((a) => a.columnName == "geocases.recovered")
              .value
              .round(),
          serious: qr.rows[i].cells
              .firstWhere((a) => a.columnName == "geocases.serious")
              .value
              .round(),
        );
        countries.add(cm);
      }

      setState(() {
        countries = countries;
        _loading = false;
        _error = false;
      });

    }
    catch(a){
      _error = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_error ? mainWidget() :  Center(child:Text("Server Error"));
  }

  Widget mainWidget() {
    return favourites == null || favourites.length == 0 ? Padding(
    padding: const EdgeInsets.all(32.0),
    child: Center(child:Text("Your favorite list is empty. You can touch the plus button next to the countries.")),
  ): _loading? Center(child: CircularProgressIndicator()) :  buildCards();
  }

  Widget buildCards()
  {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(itemBuilder: (context, index){
        var c = countries[index];
        var image = flags[c.name];
        return  c.toWidget(context,(c){
          removeCountry(c.name).then((a){
            getCases(widget.sessionid);
          });
        });

      }, itemCount:  countries.length,),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
