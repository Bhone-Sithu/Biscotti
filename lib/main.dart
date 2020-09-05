import 'dart:async';

import 'package:Learning_Helper/Features/SplashScreen.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:Learning_Helper/dbandmodels/Helper.dart';
import 'package:path/path.dart';
import 'package:Learning_Helper/dbandmodels/Subjects.dart';
import 'package:Learning_Helper/Features/update.dart';
import 'package:Learning_Helper/Features/testnoti.dart';
import 'Features/usage.dart';
import 'Features/trackusage.dart';
import 'Features/launch.dart';
import 'ui/colors.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData.dark().copyWith(
          accentColor: blue,
          splashColor: splash,
          highlightColor: splash,
          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.normal,
              splashColor: blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15)),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.85)),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: blue,
            foregroundColor: Colors.white,
          ),
          brightness: Brightness.dark,
          primaryColor: Color(0xff1A1A1A),
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: blue, fontFamily: "Arial"),
            bodyText2: TextStyle(color: blue),
            headline6: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.85)),
            subtitle1: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.85)),
            button: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.85)),
          )),
      // // home: MyHomePage(
      // //   title: "Hellu",
      // // ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  dynamic countdata;
  MyHomePage({countdata});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  List data;
  AppUsage appUsage = new AppUsage();
  String subject;
  int totalhour = 0;
  int totalmin = 0;

  //   Future<Database> database() { openDatabase(
  //   join(getDatabasesPath().toString(),'Subjects.db'),
  //   onCreate: (db, version) {
  //     return db.execute("Create table Subjects(id integer primary key, subject text, hour integer, minute integer",);

  //   },
  //   version: 1,
  // );
  //  }
  @override
  void initState() {
    super.initState();
  }

  void getUsageStats() async {
    try {
      dynamic truedata = await DbHelp.instance.aselect();

      DateTime endDate = new DateTime.now();
      DateTime startDate =
          DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
      Map<String, double> usage = await appUsage.fetchUsage(startDate, endDate);

      usage.removeWhere((key, value) => !truedata.any((element) =>
          element["appName"].toString().toLowerCase() == key.toLowerCase()));

      usage.forEach((key, value) {
        // int i = truedata.indexWhere((element) =>
        //     element["appName"].toString().toLowerCase() == key.toLowerCase());
        // key = truedata[i]["appReal"];
        // String icon = truedata[i]["appIcon"];
        int min = value.toInt() ~/ 60;
        while (min > 60) min -= 60;

        // Uint8List hellu = Uint8List.fromList(truedata[i]["appIcon"].codeUnits);

        totalhour += ((value / 60) / 60).toInt();
        totalmin += (value / 60).toInt();
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  Future getData() async {
    data = await DbHelp.instance.select();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              // 'assets/image/3667eb23-a854-4275-b95e-2d956ed4ca90_200x200.png',
              'assets/image/cookie.png',
              scale: 3.5,
            ),
            Text(
              "Biscotti",
              style: TextStyle(color: blue),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Futurebuild(count: this.widget.countdata),
          ),

          // FlatButton(
          //   onPressed: () async {
          //     totalhour = 0;
          //     totalmin = 0;
          //     dynamic b = await DbHelp.instance.localselects();
          //     await getUsageStats();
          //     print(totalhour.toString() + totalmin.toString() + "hellu");
          //     print(b[0]["totalhour"].toString() +
          //         b[0]["totalmin"].toString() +
          //         "hellu");
          //     if (totalhour < b[0]["totalhour"]) {
          //       print("hour no");
          //     } else if (totalhour == b[0]["totalhour"]) {
          //       if (totalmin <= b[0]["totalmin"]) {
          //         print("min no");
          //       } else {
          //         print("min yes");
          //       }
          //     } else {
          //       print("abosolutely yes");
          //     }
          //   },
          //   child: Text("Send noti"),
          // ),
        ],
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          showSelectedItemShadow: true,
          barBackgroundColor: blacks,
          selectedItemBackgroundColor: blue,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: blue,
        ),
        selectedIndex: 0,
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: "Home",
          ),
          FFNavigationBarItem(
            iconData: Icons.launch,
            label: "Launch",
          ),
          FFNavigationBarItem(
            iconData: Icons.data_usage,
            label: "Usage",
          ),
        ],
        onSelectTab: (index) async {
          if (index == 1) {
            HapticFeedback.selectionClick();
            Get.off(Launcher(),
                transition: Transition.rightToLeftWithFade,
                duration: Duration(milliseconds:800));
          } else if (index == 2) {
            HapticFeedback.selectionClick();
            dynamic a = await DbHelp.instance.aselect();
            dynamic b = await DbHelp.instance.localselects();
           
              Get.off(TrackUsage(
                        truedata: a,
                        truetime: b,
                      ),
                transition: Transition.rightToLeftWithFade,
                duration: Duration(milliseconds:800));
            
          }
        },
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}

class Futurebuild extends StatefulWidget {
  int count;
  Futurebuild({count});

  @override
  _FuturebuildState createState() => _FuturebuildState();
}

class _FuturebuildState extends State<Futurebuild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List>(
        future: DbHelp.instance.select(),
        initialData: List(),
        builder: (context, snapshot) {
          print(snapshot.data.length);

          return snapshot.data.length != 0
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (_, int position) {
                    final item = snapshot.data[position];
                    //get your item data here ...
                    return Column(
                      children: <Widget>[
                        if (position == 0)
                          Divider(
                            height: 12,
                            color: Colors.black,
                          ),
                        // Container(
                        //   alignment: Alignment.topLeft,
                        //   color: blue,
                        //   // decoration: new BoxDecoration(
                        //   //     // gradient: new LinearGradient(
                        //   //     //     colors: [blue, Colors.black],
                        //   //     //     begin: Alignment.centerLeft,
                        //   //     //     end: new Alignment(1, -1)),
                        //   //     borderRadius:
                        //   //         BorderRadius.all(Radius.circular(15)),
                        //   //     boxShadow: [
                        //   //       new BoxShadow(
                        //   //         color: blue,
                        //   //         offset: new Offset(5, 5),
                        //   //         blurRadius: 2,
                        //   //       )
                        //   //     ],
                        //   //     ),
                        Card(
                          color: blacks,
                          elevation: 5,
                          shadowColor: blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            title: Text(item.row[1].toString() + "\n"),
                            subtitle: Text(
                              item.row[2].toString() +
                                  " hours " +
                                  item.row[3].toString() +
                                  " minutes ",
                              // style: TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: blue,
                                size: 28,
                              ),
                              onPressed: () async {
                                HapticFeedback.selectionClick();
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Really?"),
                                          content: Text(
                                              "Want to delete ${item.row[1].toString()}?"),
                                          actions: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: blacks,
                                                // gradient: new LinearGradient(
                                                //     colors: [blue, Colors.black],
                                                //     begin: Alignment.centerLeft,
                                                //     end: new Alignment(0.5, -1)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Colors.red[400],
                                                    offset:
                                                        new Offset(2.5, 2.5),
                                                    blurRadius: 2,
                                                  )
                                                ],
                                              ),
                                              child: FlatButton(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 12, 0, 12),
                                                  splashColor: blue,
                                                  onPressed: () async {
                                                    HapticFeedback
                                                        .selectionClick();
                                                    await DbHelp.instance
                                                        .delete(item.row[0]);
                                                    this.setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Delete")),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: blacks,
                                                // gradient: new LinearGradient(
                                                //     colors: [blue, Colors.black],
                                                //     begin: Alignment.centerLeft,
                                                //     end: new Alignment(0.5, -1)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: blue,
                                                    offset:
                                                        new Offset(2.5, 2.5),
                                                    blurRadius: 2,
                                                  )
                                                ],
                                              ),
                                              child: FlatButton(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 12, 0, 12),
                                                  splashColor: blue,
                                                  onPressed: () async {
                                                    HapticFeedback
                                                        .selectionClick();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No")),
                                            ),
                                          ],
                                        ));
                              },
                            ),
                            contentPadding: EdgeInsets.all(10),
                            onTap: () async {
                              HapticFeedback.selectionClick();
                              List datahellu =
                                  await DbHelp.instance.select1(item.row[0]);
                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Update(
                                      data: item,
                                      hellu: datahellu,
                                    ),
                                  )).whenComplete(() => this.setState(() {}));
                            },
                          ),
                        ),

                        Divider(
                          height: 20,
                          color: Colors.black,
                        ),
                        if (position == snapshot.data.length - 1)
                          Column(
                            children: <Widget>[
                              Divider(
                                height: 10,
                                color: Colors.black,
                              ),
                              Container(
                                decoration: new BoxDecoration(
                                  gradient: new LinearGradient(
                                      colors: [blue, Colors.black],
                                      begin: Alignment.centerLeft,
                                      end: new Alignment(0.5, -1)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  // color: Color.fromRGBO(0, 200, 255, 0.6),

                                  boxShadow: [
                                    new BoxShadow(
                                      color: blue,
                                      offset: new Offset(2.5, 2.5),
                                      blurRadius: 2,
                                    )
                                  ],
                                ),
                                child: ListTile(
                                  title: Center(
                                      child: Text(
                                    "+",
                                    style: TextStyle(fontSize: 35),
                                  )),
                                  onTap: () async {
                                    HapticFeedback.selectionClick();
                                    await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Update(
                                                data: {"subject": null},
                                              ),
                                            ))
                                        .whenComplete(
                                            () => this.setState(() {}));
                                  },
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                              Divider(
                                height: 25,
                                color: Colors.black,
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                )
              :  Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 400),
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [blue, Colors.black],
                            begin: Alignment.centerLeft,
                            end: new Alignment(0.5, -1)),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        // color: Color.fromRGBO(0, 200, 255, 0.6),

                        boxShadow: [
                          new BoxShadow(
                            color: blue,
                            offset: new Offset(2.5, 2.5),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Center(
                            child: Text(
                          "Add Subject",
                          style: TextStyle(fontSize: 15),
                        )),
                        onTap: () async {
                          HapticFeedback.selectionClick();
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Update(
                                  data: {"subject": null},
                                );}
                              )).whenComplete(() => this.setState(() {}));
                        },
                        contentPadding: EdgeInsets.all(10),
                      ),
                    );
        },
      ),
    );
  }
}
