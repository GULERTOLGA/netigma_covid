import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

typedef RemoveButtonClicked<T> = void Function(T value);

class CountryModel
{
  final String name;
  final int total;
  final int newCases;
  final int totalDeaths;
  final int newDeaths;
  final int actives;
  final int recovered;
  final int serious;
  final double lat;
  final double lng;


  CountryModel({ this.name, this.total, this.newCases, this.totalDeaths, this.newDeaths, this.actives, this.recovered, this.serious, this.lat,this.lng});

  final formatter = new NumberFormat("#,###");

  Widget toWidget(BuildContext context, RemoveButtonClicked onPressed)
  {
    var image = flags[this.name];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Colors.black12,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: ListTile(
          trailing:IconButton(
            onPressed: () {
              if(onPressed != null)
                onPressed(this);

            },
            icon: Icon(Icons.remove),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: image !=null ? image :  CircleAvatar(child: Text(this.name[0]),),
          ),
          title: Text(this.name,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Total Cases : ${formatter.format(this.total)}"),
                Text("New Cases  : ${formatter.format(this.newCases)}"),
                Text("Total Deaths : ${formatter.format(this.totalDeaths)}"),
                Text("Recovered : ${formatter.format(this.recovered)}"),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}