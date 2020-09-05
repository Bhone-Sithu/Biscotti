import 'package:Learning_Helper/Features/potatoes.dart';
import 'package:Learning_Helper/dbandmodels/Helper.dart';
import 'package:Learning_Helper/ui/colors.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:Learning_Helper/Features/usage.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:Learning_Helper/main.dart';
import 'launch.dart';

class TrackUsage extends StatefulWidget {
  TrackUsage({Key key, this.truedata, this.truetime}) : super(key: key);
  dynamic truetime;
  final dynamic truedata;
  //final  dynamic truetime;
  _TrackUsageState createState() => _TrackUsageState();
}

class _TrackUsageState extends State<TrackUsage> {
  AppUsage appUsage = new AppUsage();
  String apps = 'Unknown';
  List data = [];
  int maxhour = 0;
  int maxmin = 0;
  int totalhour = 0;
  int totalmin = 0;
  bool exceeded = false;
  Dialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Maximum Usage"),
            content: Row(children: <Widget>[
              NumberPicker.integer(
                  initialValue: maxhour,
                  minValue: 0,
                  maxValue: 24,
                  onChanged: (value) {
                    this.setState(() {
                      maxhour = value;
                    });
                  }),
              NumberPicker.integer(
                  initialValue: maxmin,
                  minValue: 0,
                  maxValue: 60,
                  step: 5,
                  onChanged: (value) {
                    maxmin = value;
                    this.setState(() {});
                  })
            ]),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    HapticFeedback.selectionClick();

                    DbHelp.instance
                        .localupdate({"id": 0, "totalhour": 0, "totalmin": 0});
                    widget.truetime = await DbHelp.instance.localselects();
                    this.setState(() {
                      maxhour = 0;
                      maxmin = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Reset")),
              FlatButton(
                  onPressed: () async {
                    HapticFeedback.selectionClick();
                    if (maxmin == 60) {
                      maxhour++;
                      maxmin = 0;
                    }
                    if (maxhour == 25) maxhour--;
                    DbHelp.instance.localupdate(
                        {"id": 0, "totalhour": maxhour, "totalmin": maxmin});
                    widget.truetime = await DbHelp.instance.localselects();
                    exceeded = await exceed(totalhour, totalmin);
                    this.setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Set")),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getUsageStats();
  }

  a(String key) async {
    return await DbHelp.instance.aselects(key);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  void getUsageStats() async {
    try {
      DateTime endDate = new DateTime.now();
      DateTime startDate =
          DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
      Map<String, double> usage = await appUsage.fetchUsage(startDate, endDate);
      if(widget.truedata != null)
      {
      usage.removeWhere((key, value) => !widget.truedata.any((element) =>
          element["appName"].toString().toLowerCase() == key.toLowerCase()));
      usage.forEach((key, value) {
        int i = widget.truedata.indexWhere((element) =>
            element["appName"].toString().toLowerCase() == key.toLowerCase());
        key = widget.truedata[i]["appReal"];
        // String icon = widget.truedata[i]["appIcon"];
        int min = value.toInt() ~/ 60;
        int hour = value ~/ 3600;
        while (min > 60) {
          min -= 60;
        }
        print(value);

        // Uint8List hellu = Uint8List.fromList(widget.truedata[i]["appIcon"].codeUnits);
        this.data.removeWhere((element) => element["appName"] == key);
        this
            .data
            .add({"appName": key, "totalmin": value, "hour": hour, "min": min});

        totalhour += hour;
        totalmin += min;
        while (totalmin >= 60) {
          totalmin -= 60;
          totalhour++;
        }
      }
      );
      }
      exceeded = await exceed(totalhour, totalmin);

      setState(() => apps = makeString(usage));
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  String makeString(Map<String, double> usage) {
    String result = '';
    usage.forEach((k, v) {
      String appName = k.split('.').last;
      String timeInMins = (v / 60).toStringAsFixed(2);
      result += '$appName : $timeInMins minutes\n';
    });
    return result;
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.apps),
            onPressed: () async {
              HapticFeedback.selectionClick();
              List a = await DbHelp.instance.aselect1();
              Get.off(Usage(truedata: a),
                  transition: Transition.rightToLeftWithFade,
                  duration: Duration(milliseconds: 800));
            },
            iconSize: 45,
            color: blue,
            splashColor: Colors.transparent,
          )
        ],
      ),
      // body: Text(
      //   apps,
      //   overflow: TextOverflow.ellipsis ,
      //   style: TextStyle(
      //     fontSize: 20.0, // insert your font size here
      //   ),
      // ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
                controller: _scrollController,
                child: data.length != 0
                    ? ListView.builder(
                        itemCount: data.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) => ListTile(
                              title: Text(data[index]["appName"]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[index]["hour"].toString() +
                                      " hour " +
                                      data[index]["min"].toString() +
                                      " minutes"),
                                  Divider(height: 30),
                                ],
                              ),
                            ))
                    : 
                    (data.length == 0 && widget.truedata.isEmpty)?
                    RaisedButton.icon(
                        onPressed: () async {
                          HapticFeedback.selectionClick();
                          List a = await DbHelp.instance.aselect1();
                          Get.off(Usage(truedata: a),
                              transition: Transition.rightToLeftWithFade,
                              duration: Duration(milliseconds: 800));
                        },
                        color: blue,
                        icon: Icon(Icons.apps),
                        label: Text("Add your apps to track their usage"),
                      ):
                      RaisedButton.icon(
                        onPressed: () async {
                          HapticFeedback.selectionClick();
                          getUsageStats();
                        },
                        color: blue,
                        icon: Icon(Icons.settings),
                        label: Text("Allow Biscotti in setting\nPrivacy>Usage access"),
                      ),
          )),
          Center(
            child: Text("Total:" +
                totalhour.toString() +
                " hours " +
                totalmin.toString() +
                " minutes"),
          ),
          !this.widget.truetime.isEmpty
              ? Center(
                  child: Text("Max Usage: " +
                      this.widget.truetime[0]["totalhour"].toString() +
                      " hours " +
                      this.widget.truetime[0]["totalmin"].toString() +
                      " minutes"),
                )
              : Center(
                  child: Text("Max Usage: " +
                      maxhour.toString() +
                      " hours " +
                      maxmin.toString() +
                      " minutes"),
                ),
          exceeded
              ? Text(
                  "App Usage Exceeding!",
                  style: TextStyle(
                    color: Colors.red[300],
                  ),
                )
              : Text(""),
          RaisedButton(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              HapticFeedback.selectionClick();
              Dialog(context);
            },
            child: Text('Change Max Usage'),
          ),
          Divider(
            height: 50,
            color: Colors.transparent,
          )
        ],
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: blacks,
          selectedItemBackgroundColor: blue,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: blue,
        ),
        selectedIndex: 2,
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: "Home",
          ),
          FFNavigationBarItem(
            iconData: Icons.launch,
            label: "Launch",
          ),
          FFNavigationBarItem(iconData: Icons.data_usage, label: "Usage"),
        ],
        onSelectTab: (index) async {
          if (index == 0) {
            HapticFeedback.selectionClick();
            Get.off(MyHomePage(),
                transition: Transition.leftToRightWithFade,
                duration: Duration(milliseconds: 800));
          } else if (index == 1) {
            HapticFeedback.selectionClick();
            Get.off(Launcher(),
                transition: Transition.leftToRightWithFade,
                duration: Duration(milliseconds: 800));
          }
        },
      ),
      floatingActionButton: Container(
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: blue,
            offset: new Offset(2.5, 2.5),
            blurRadius: 2,
          )
        ], borderRadius: BorderRadius.all(Radius.circular(30))),
        child: FloatingActionButton(
            backgroundColor: blacks,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            onPressed: () {
              HapticFeedback.selectionClick();
              totalhour = 0;
              totalmin = 0;

              getUsageStats();
            },
            child: Icon(Icons.refresh)),
      ),
    );
  }
}
