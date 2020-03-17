import 'package:flutter/material.dart';
import 'package:netigma_covid/total_deaths.dart';

import 'cluster_map.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

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
  String sessionid = "";

  Future<ClientUser> singIn(String email, String password) async {
    ClientUser user = new ClientUser(
      userName: email,
      password: password,
      sessionid: "",
    );

    final response = await http
        .post("http://ssltest.netcad.com.tr/covid/gisapi/Authentication/Login",
            body: user.toJsonMap())
        .timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      var tt = json.decode(response.body);
      var t = tt["sessionid"];
      var g = 1;
      setState(() {
        sessionid = t;
      });

      getCases(sessionid);
    }
  }


  dynamic total ="...";
  dynamic newcases="...";
  dynamic totaldeaths="...";
  dynamic newdeaths="...";
  dynamic actives="...";
  dynamic recoveresds="...";




  void getCases(sessiionid) async
  {
    //http://ssltest.netcad.com.tr/covid/gisapi/query/Template?TemplateName=corona_totals&SessionID=7f9da62287d841708fe8a05d6c082a7d&enableCache=true
    final response = await http
        .get("http://ssltest.netcad.com.tr/covid/gisapi/query/Template?TemplateName=corona_totals&SessionID=${sessiionid}");
    var t = response.body;
    var tt = json.decode(response.body);
    
    var c = 1;
    setState(() {
      total = tt["Rows"][0]["Cells"][0]["Value"];
      newcases = tt["Rows"][0]["Cells"][1]["Value"];
      totaldeaths = tt["Rows"][0]["Cells"][2]["Value"];
      newdeaths = tt["Rows"][0]["Cells"][3]["Value"];
      actives = tt["Rows"][0]["Cells"][4]["Value"];
      recoveresds = tt["Rows"][0]["Cells"][6]["Value"];

    });


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    singIn("covidguest", "covidguest");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 4,
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
                  Tab(
                    icon: new Icon(Icons.settings),
                  )
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
                  child: Text('NETIGMA'),
                  decoration: BoxDecoration(),
                ),
                ListTile(
                  title: Text('netimga.io'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('netcad.com.tr'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                Divider(),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("NETIGMA Covid Demo"),
          ),
          body: TabBarView(
            children: [
              new Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(child: buildCards()),
                ),
              ),
              new MapSample(),
              new TotalDeaths(sessionid: sessionid),
              new Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCards() {
    return Column(children: <Widget>[
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.pink,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
          child: ListTile(
            leading: Icon(Icons.all_inclusive, size: 70),
            title: Text('Total Cases', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(total.toString(), style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                Text("17.03.2020 03:53"),
              ],
            ),
          ),
        ),
      ),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.orange,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
          child: ListTile(
            leading: Icon(Icons.new_releases, size: 70),
            title: Text('New Cases', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(newcases.toString(), style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                Text("17.03.2020 03:53"),
              ],
            ),
          ),
        ),
      ),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.red,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
          child: ListTile(
            title: Text('Total Deaths', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold )),
            leading: Icon(Icons.cancel, size: 70),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(totaldeaths.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold )),
                SizedBox(height: 5),
                Text("17.03.2020 03:53"),
              ],
            ),
          ),
        ),
      ),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.blueGrey,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
          child: ListTile(
            leading: Icon(Icons.gesture, size: 70),
            title: Text('Recovereds', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(recoveresds.toString(), style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                Text("17.03.2020 03:53"),
              ],
            ),
          ),
        ),
      ),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.purple,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
          child: ListTile(
            leading: Icon(Icons.access_time, size: 70),
            title: Text('Active Cases', style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(actives.toString(), style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                Text("17.03.2020 03:53"),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class ClientUser {
  final String userName;
  final String password;
  final String sessionid;
  final String firstName;
  final String lastName;
  final String email;
  final bool isNetAdmin;
  final String uid;

  ClientUser(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.isNetAdmin,
      this.userName,
      this.password,
      this.sessionid});

  factory ClientUser.fromJson(Map<String, dynamic> json) {
    return new ClientUser(
      userName: json["userName"],
      password: json["password"],
      sessionid: json["sessionid"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      uid: json["uid"],
      isNetAdmin: json["isNetAdmin"],
    );
  }

  Map toJsonMap() {
    Map map = {
      'userName': userName,
      'password': password,
      'sessionid': sessionid
    };
    return map;
  }
}
