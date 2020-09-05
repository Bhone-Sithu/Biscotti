import 'package:Learning_Helper/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:Learning_Helper/dbandmodels/Helper.dart';
import 'package:get/route_manager.dart';
import 'trackusage.dart';

class Usage extends StatefulWidget {
  List<dynamic> truedata;
  Usage({Key key, this.truedata}) : super(key: key);
  @override
  _UsageState createState() => _UsageState();
}

class _UsageState extends State<Usage> {
  bool check = false;
  int count = 0;
  List<Application> appsnew;
  Future<List<Application>> getApp() async {
    return await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
    );
  }

  //  hello(String name) async{
  //    print("hello");
  //     return await DbHelp.instance.aselects(name);
  //   }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.truedata);
  }

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
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: blue,
              ),
              onPressed: () async {
                dynamic a = await DbHelp.instance.aselect();
                dynamic b = await DbHelp.instance.localselects();
                Get.off(
                    TrackUsage(
                      truedata: a,
                      truetime: b,
                    ),
                    transition: Transition.leftToRightWithFade,
                    duration: Duration(milliseconds: 800));
              },
            )),
        body: Container(
          child: FutureBuilder(
            future: this.getApp(),
            builder: (context, snap) {
              if (snap.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (appsnew == null) appsnew = snap.data;
                return ListView.builder(
                  itemCount: appsnew.length,
                  itemBuilder: (context, position) {
                    Application app = appsnew[position];
                    String name = app.packageName.trim().toLowerCase();

                    if (widget.truedata.any((element) =>
                        element.trim().toLowerCase() == name && count < 1)) {
                      app.checked = true;
                    } else if (count < 1) app.checked = false;
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: app is ApplicationWithIcon
                              ? AppIcon(
                                  icon: app.icon,
                                )
                              // ? CircleAvatar(
                              //     backgroundImage: MemoryImage(app.icon),
                              //     backgroundColor: Colors.white,
                              //     radius: 25,
                              //   )
                              : null,
                          title: Text("${app.appName}"),
                          trailing: Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                                activeColor: blue,
                                value: app.checked,
                                onChanged: (value) async {
                                  app.checked = value;
                                  if (value) {
                                    String hi;
                                    app is ApplicationWithIcon
                                        ? hi = app.icon.toString()
                                        : hi = null;
                                    await DbHelp.instance.ainserts({
                                      DbHelp.appName: name,
                                      DbHelp.appReal:
                                          app.appName.trim().toLowerCase(),
                                    });
                                  } else {
                                    await DbHelp.instance.adelete(name);
                                  }
                                  print(await DbHelp.instance.aselect());
                                  this.setState(() {
                                    this.count++;
                                  });
                                }),
                          ),
                        ),
                        Divider(
                          height: 20.0,
                        )
                      ],
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class AppIcon extends StatelessWidget {
  final dynamic icon;
  const AppIcon({this.icon});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: MemoryImage(icon),
      backgroundColor: Colors.white,
      radius: 25,
    );
  }
}
