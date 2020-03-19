import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netigma_covid/meta/query_result.dart';
import 'package:netigma_covid/total_deaths.dart';
import 'package:url_launcher/url_launcher.dart';

import 'authentication/auth.dart';
import 'authentication/client_uset.dart';
import 'card_widget.dart';
import 'cluster_map.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'meta/query.dart';

void main() => runApp(AuthProvider(auth: Auth(), child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BusWatch',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
      home: MyHomePage(title: 'Covid19 Stats'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sessionID = "";
  int total =0;
  int newCases=0 ;
  int totalDeaths=0 ;
  int newDeaths=0 ;
  int actives=0 ;
  int recovered =0;
  int serious =0;

  Future<ClientUser> login(String email, String password) async {
    ClientUser user = new ClientUser(
      userName: email,
      password: password,
      sessionid: "",
    );

    return AuthProvider.of(context)
        .auth
        .singIn("covidguest", "covidguest", null, null, null);
  }

  void getCases(sessiionid) async {
    //https://covid19.netigma.io/covid/gisapi/query/Template?TemplateName=corona_totals&SessionID=7f9da62287d841708fe8a05d6c082a7d&enableCache=true
    final response = await http.get(
        "https://covid19.netigma.io/covid/gisapi/query/Template?TemplateName=corona_totals&SessionID=${sessiionid}");
    var t = response.body;
    var tt = json.decode(response.body);


    var qr = QueryResult.fromJson(tt, new Query());




    var c = 1;
    setState(() {
      total =  qr.rows[0].cells.firstWhere((a)=>a.columnName == "geocases.total").value.round();
      newCases = qr.rows[0].cells.firstWhere((a)=>a.columnName == "geocases.newcases").value.round();
      totalDeaths =  qr.rows[0].cells.firstWhere((a)=>a.columnName == "geocases.deaths").value.round();
      newDeaths = qr.rows[0].cells.firstWhere((a)=>a.columnName == "geocases.newdeaths").value.round();
      actives =  qr.rows[0].cells.firstWhere((a)=>a.columnName == "geocases.active").value.round();
      recovered =  qr.rows[0].cells.firstWhere((a)=>a.columnName == "geocases.recovered").value.round();
      serious =  qr.rows[0].cells.firstWhere((a)=>a.columnName == "geocases.serious").value.round();
    });




  }


  int y = 1000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    new Future.delayed(Duration.zero, () {
      login("covidguest", "covidguest").then((c) {
        setState(() {
          sessionID = c.sessionid;
          getCases(sessionID);
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: ThemeData.dark().primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: new TabBar(
                tabs: [
                  Tab(
                    icon: new Icon(Icons.home),
                  ),
                  Tab(
                    icon: new Icon(Icons.map),
                  ),
                  Tab(
                    icon: new Icon(Icons.list),
                  ),

                ],
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.red,
              ),
            ),
          ),
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 90,

                        child: Image(
                          width: 140,
                            image: AssetImage('assets/images/tick.png')),
                      ),
                      Center(
                          child: Text("Covid19 Outbreak",
                              style: TextStyle(color: Colors.black45))),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color:Colors.white
                  ),
                ),
                ListTile(
                  title: Text('covid19.netigma.io'),
                  onTap: () {
                    _launchURL("https://covid19.netigma.io");
                    // Update the state of the app.
                    // ...
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('netigma.io'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                    _launchURL("https://netigma.io");
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('netcad.com.tr'),
                  onTap: () {
                    _launchURL("https://netcad.com.tr");


                    // Update the state of the app.
                    // ...
                  },
                ),
                Divider(),

                ListTile(
                  title: Center(child: Text('Data by WHO & Wikipedia', style: TextStyle(color: Colors.grey, fontSize: 12),)),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("Covid 19 Tracker"),
          ),
          body: TabBarView(
            children: [
              new Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(child: buildCards()),
                ),
              ),
              new MapSample(sessionid: sessionID,),
              new TotalDeaths(sessionid: sessionID),

            ],
          ),
        ),
      ),
    );
  }


  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildCards() {

    return Column(children: <Widget>[
      CardWidget(title: "Total Cases", color: Colors.pink, value: total, icon: Icons.all_inclusive),
      CardWidget(title: "New Cases", color: Colors.orange, value: newCases, icon: Icons.new_releases),
      CardWidget(title: "Total Deaths", color: Colors.red, value: totalDeaths, icon: Icons.remove_circle),
      CardWidget(title: "Recovered", color: Colors.blueGrey, value: recovered, icon: Icons.healing),
      CardWidget(title: "Active Cases", color: Colors.purple, value: actives, icon: Icons.access_time),
      CardWidget(title: "Serious", color: Colors.brown, value: serious, icon: Icons.announcement),

    ]);
  }
}


