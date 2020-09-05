import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti extends StatefulWidget {
  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  FlutterLocalNotificationsPlugin noti;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noti = new FlutterLocalNotificationsPlugin();
    var and =   new AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = new IOSInitializationSettings();
    var init = new InitializationSettings(and, ios);
    noti.initialize(init);
    
   
  }
  showNoti() async {
    var and = new AndroidNotificationDetails("channelId", "channelName", "channelDescription",enableVibration: true);
    var ios = new IOSNotificationDetails();
    var init = new NotificationDetails(and, ios);
    Timer.periodic(Duration(seconds: 5), (tick){
      noti.show(0, "title", "body", init );
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Noti")
      ),
      body: FlatButton(onPressed: () {
        showNoti();
      }, child: Text("Noti")),
    );
  }
}
