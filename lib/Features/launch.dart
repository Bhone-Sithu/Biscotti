import 'dart:math';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:Learning_Helper/dbandmodels/Helper.dart';
import 'package:Learning_Helper/ui/colors.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'trackusage.dart';
import 'package:Learning_Helper/main.dart';

class Launcher extends StatefulWidget {
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  int ans;
  int m1, m2;

  Dialog(BuildContext context, String name, int level, String package) {
    return showDialog(
        context: context,
        builder: (context) {
          int dif;
          if (level > 0 && level <= 10)
            dif = 10;
          else if (level > 10 && level <= 20)
            dif = 100;
          else if (level > 20 && level <= 30)
            dif = 1000;
          else if (level > 30) dif = 10000;
          Random random = new Random();

          m1 = random.nextInt(dif);
          m2 = random.nextInt(dif);
          String errs = null;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text("$name"),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (level <= 10)
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text("Level: $level "),
                            Text(
                              m1.toString() + " x " + m2.toString(),
                              style: TextStyle(
                                color: blue,
                              ),
                            ),
                            Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: "Answer",
                                  errorText: errs,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: blue),
                                  )),
                              scrollPadding: EdgeInsets.all(20),
                              onChanged: (value) {
                                ans = int.parse(value);
                                setState(() {
                                  errs = null;
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(),
                            ),
                          ],
                        ),
                      ),
                    //Level 10 above
                    if (level > 10 && level <= 20)
                      Column(
                        children: <Widget>[
                          Text("Level: $level"),
                          // Text("Level: ($level) Medium Illenium \n (Just do it!)"),
                          Text(
                            m1.toString() + " x " + m2.toString(),
                            style: TextStyle(
                              color: blue,
                            ),
                          ),
                          Divider(
                            height: 20,
                            color: Colors.transparent,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Answer",
                                errorText: errs,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: blue),
                                )),
                            onChanged: (value) {
                              ans = int.parse(value);
                              setState(() {
                                errs = null;
                              });
                            },
                            keyboardType: TextInputType.numberWithOptions(),
                          ),
                        ],
                      ),
                    if (level > 20 && level <= 30)
                      Column(
                        children: <Widget>[
                          Text("Level: $level"),
                          // Text(
                          //     "Level: ($level) It\'s Insane. Just Try Again! \n (Nah Nah... Don't Use Calculator)"),
                          Text(
                            m1.toString() + " x " + m2.toString(),
                            style: TextStyle(
                              color: blue,
                            ),
                          ),
                          Divider(
                            height: 20,
                            color: Colors.transparent,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Answer",
                                errorText: errs,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: blue),
                                )),
                            onChanged: (value) {
                              ans = int.parse(value);
                              setState(() {
                                errs = null;
                              });
                            },
                            keyboardType: TextInputType.numberWithOptions(),
                          ),
                        ],
                      ),
                    if (level > 30)
                      Column(
                        children: <Widget>[
                          Text("Level: $level"),
                          // Text(
                          //     "Level: ($level) It\'s Impossible But You Are POSSIBLE! \n (Nah Nah... Don't Use Calculator)"),
                          Text(
                            m1.toString() + " x " + m2.toString(),
                            style: TextStyle(
                              color: blue,
                            ),
                          ),
                          Divider(
                            height: 20,
                            color: Colors.transparent,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Answer",
                                errorText: errs,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: blue),
                                )),
                            initialValue: "",
                            onChanged: (value) {
                              setState(() {
                                errs = null;
                              });
                              ans = int.parse(value);
                            },
                            keyboardType: TextInputType.numberWithOptions(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 90, 20),
                  decoration: BoxDecoration(
                    color: blacks,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      new BoxShadow(
                        color: blue,
                        offset: new Offset(2.5, 2.5),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: FlatButton(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      splashColor: blue,
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        if (ans == (m1 * m2)) {
                          DbHelp.instance.lupdate({
                            DbHelp.appReal: package,
                            "Level": level + 1,
                          });

                          DeviceApps.openApp(package);
                        } else {
                          setState(() {
                            errs = "Incorrect! Please try again.";
                          });
                        }
                      },
                      child: Text("Answer")),
                ),
              ],
            );
          });
        });
  }

  Future<List<Application>> getApp() async {
    return await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Random random = new Random();
    m1 = random.nextInt(10);
    m2 = random.nextInt(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
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
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder(
            future: this.getApp(),
            builder: (context, snap) {
              if (snap.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                List appsnew = snap.data;
                return ListView.builder(
                  itemCount: appsnew.length,
                  itemBuilder: (context, position) {
                    Application app = appsnew[position];
                    String name = app.packageName.trim().toLowerCase();
                    
                    return Column(
                      children: <Widget>[
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          leading: app is ApplicationWithIcon
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(app.icon),
                                  backgroundColor: Colors.white10,
                                  radius: 25,
                                )
                              : null,
                          onTap: () async {
                            HapticFeedback.selectionClick();
                            List hi =
                                await DbHelp.instance.lselects(app.packageName);
                            if (hi.isNotEmpty) {
                              Dialog(context, app.appName, hi[0]["Level"],
                                  app.packageName);
                            } else {
                              await DbHelp.instance.linserts({
                                DbHelp.appName: app.appName,
                                DbHelp.appReal: app.packageName,
                                "Level": 1,
                              });
                              Dialog(context, app.appName, 1, app.packageName);
                            }
                          },
                          title: Text(
                            "${app.appName}",
                          ),
                          trailing: Icon(
                            Icons.launch,
                            color: blue,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        ),
                        // Divider(
                        //   height: 20.0,
                        //   thickness: 2.5,
                        // )
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: blacks,
            selectedItemBackgroundColor: blue,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: blue,
          ),
          selectedIndex: 1,
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
        ));
  }
}
