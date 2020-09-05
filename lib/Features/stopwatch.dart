import 'package:Learning_Helper/main.dart';
import 'package:Learning_Helper/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'update.dart';
import 'package:Learning_Helper/dbandmodels/Helper.dart';

class StopWatch extends StatefulWidget {
  UpdateState parent;
  List hellu;
  StopWatch({this.parent, this.hellu});
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    onChange: (value) => ('onChange $value'),
    onChangeSecond: (value) => ('onChangeSecond $value'),
    onChangeMinute: (value) => ('onChangeMinute $value'),
  );
  int hour = 0;
  int seconds = 0;
  int minutes = 0;
  bool play = true;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.minuteTime.listen((value) => this.setState(() {
          minutes = value;
          if (minutes > 60) {
            hour++;
            minutes -= 60;
          }
          print(seconds);
        }));
    _stopWatchTimer.secondTime.listen((value) => this.setState(() {
          while (value > 60) value -= 60;
          seconds = value;
          if (seconds >= 60) {
            minutes++;
            seconds -= 60;
          }
          if (minutes >= 60) {
            hour++;
            minutes -= 60;
          }
          print(seconds);
        }));
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Divider(
        color: Colors.black,
        height: 25,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            hour.toString() +
                "h : " +
                minutes.toString() +
                "m : " +
                seconds.toString() +
                "s",
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.9),
                fontFamily: 'D',
                fontWeight: FontWeight.w700,
                fontSize: 35),
          ),
          play
              ? IconButton(
                  splashColor: blue,
                  splashRadius: 30,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _stopWatchTimer.onExecute.add(StopWatchExecute.start);

                    this.setState(() {
                      play = !play;
                    });
                  },
                  icon: Icon(Icons.play_circle_outline),
                  color: blue,
                  iconSize: 70,
                )
              : IconButton(
                  splashColor: blue,
                  splashRadius: 30,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);

                    this.setState(() {
                      play = !play;
                    });
                  },
                  icon: Icon(Icons.pause_circle_outline),
                  color: blue,
                  iconSize: 70,
                )
        ],
      ),

      // Padding(
      //         padding: const EdgeInsets.only(bottom: 0),
      //         child: StreamBuilder<int>(
      //           stream: _stopWatchTimer.minuteTime,
      //           initialData: _stopWatchTimer.minuteTime.value,
      //           builder: (context, snap) {
      //             final value = snap.data;
      //             // print('Listen every minute. $value');
      //             return Column(
      //               children: <Widget>[
      //                 Padding(
      //                     padding: const EdgeInsets.all(8),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       crossAxisAlignment: CrossAxisAlignment.center,
      //                       children: <Widget>[
      //                         const Padding(
      //                           padding: EdgeInsets.symmetric(horizontal: 4),
      //                           child: Text(
      //                             'minute',
      //                             style: TextStyle(
      //                               fontSize: 17,
      //                               fontFamily: 'Helvetica',
      //                             ),
      //                           ),
      //                         ),
      //                         Padding(
      //                           padding:
      //                               const EdgeInsets.symmetric(horizontal: 4),
      //                           child: Text(
      //                             value.toString(),
      //                             style: TextStyle(
      //                                 fontSize: 30,
      //                                 fontFamily: 'Helvetica',
      //                                 fontWeight: FontWeight.bold),
      //                           ),
      //                         ),
      //                       ],
      //                     )),
      //               ],
      //             );
      //           },
      //         ),
      //       ),
      // Padding(
      //         padding: const EdgeInsets.only(bottom: 0),
      //         child: StreamBuilder<int>(
      //           stream: _stopWatchTimer.secondTime,
      //           initialData: _stopWatchTimer.secondTime.value,
      //           builder: (context, snap) {
      //             final value = snap.data;
      //             // print('Listen every second. $value');
      //             return Column(
      //               children: <Widget>[
      //                 Padding(
      //                     padding: const EdgeInsets.all(8),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       crossAxisAlignment: CrossAxisAlignment.center,
      //                       children: <Widget>[
      //                         const Padding(
      //                           padding: EdgeInsets.symmetric(horizontal: 4),
      //                           child: Text(
      //                             'second',
      //                             style: TextStyle(
      //                               fontSize: 17,
      //                               fontFamily: 'Helvetica',
      //                             ),
      //                           ),
      //                         ),
      //                         Padding(
      //                           padding:
      //                               const EdgeInsets.symmetric(horizontal: 4),
      //                           child: Text(
      //                             value.toString(),
      //                             style: TextStyle(
      //                                 fontSize: 30,
      //                                 fontFamily: 'Helvetica',
      //                                 fontWeight: FontWeight.bold),
      //                           ),
      //                         ),
      //                       ],
      //                     )),
      //               ],
      //             );
      //           },
      //         ),
      //       ),
      Padding(
          padding: const EdgeInsets.all(2),
          child: Column(children: <Widget>[
            //       Padding(
            //         padding: const EdgeInsets.only(bottom: 0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: <Widget>[
            //             Padding(
            //               padding: const EdgeInsets.all(12),
            //               child: RaisedButton(
            //                 padding: const EdgeInsets.all(4),
            //                 color: Colors.lightBlue,
            //                 shape: const StadiumBorder(),
            //                 onPressed: () async {
            //                   print(widget.parent.supdate);
            //                   print(widget.hellu);
            //                   _stopWatchTimer.onExecute.add(StopWatchExecute.start);
            //                 },
            //                 child: Text(
            //                   'Start',
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.all(12),
            //               child: RaisedButton(
            //                 padding: const EdgeInsets.all(4),
            //                 color: Colors.green,
            //                 shape: const StadiumBorder(),
            //                 onPressed: () async {
            //                   _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
            //                 },
            //                 child: Text(
            //                   'Stop',
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.all(12),
            //               child: RaisedButton(
            //                 padding: const EdgeInsets.all(4),
            //                 color: Colors.red,
            //                 shape: const StadiumBorder(),
            //                 onPressed: () async {
            //                   _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
            //                 },
            //                 child: Text(
            //                   'Reset',
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: <Widget>[
            //             Padding(
            //               padding: const EdgeInsets.all(0),
            //               child: RaisedButton(
            //                 padding: const EdgeInsets.all(4),
            //                 color: Colors.deepPurpleAccent,
            //                 shape: const StadiumBorder(),
            //                 onPressed: () async {
            //                   _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
            //                 },
            //                 child: Text(
            //                   'Lap',
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(30),
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
                      splashColor: blue,
                      onPressed: () async {
                        HapticFeedback.selectionClick();
                        await _stopWatchTimer.onExecute
                            .add(StopWatchExecute.stop);
                        int min = this.minutes + widget.hellu[0]["minute"];
                        int hourss = this.hour + widget.hellu[0]["hour"];
                        while (min > 60) {
                          min -= 60;
                          hourss++;
                        }
                        await DbHelp.instance.update({
                          DbHelp.id: widget.hellu[0]["id"],
                          DbHelp.subject: widget.parent.supdate == null
                              ? widget.hellu[0]["subject"]
                              : widget.parent.supdate,
                          DbHelp.hour: hourss,
                          DbHelp.minute: min,
                        });
                        Get.offAll(MyHomePage(),
                            transition: Transition.cupertinoDialog,
                            duration: Duration(seconds: 1));
                      },
                      child: Text("Update")),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: blacks,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.red[400],
                        offset: new Offset(2.5, 2.5),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: FlatButton(
                      onPressed: () async {
                        HapticFeedback.selectionClick();
                        await _stopWatchTimer.onExecute
                            .add(StopWatchExecute.stop);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  title: Text("Sure?"),
                                  content: Text(
                                      "Want to go back? This action will reset your timer!"),
                                  actions: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: blacks,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.red[400],
                                            offset: new Offset(2.5, 2.5),
                                            blurRadius: 2,
                                          )
                                        ],
                                      ),
                                      child: FlatButton(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 15, 0, 15),
                                          splashColor: blue,
                                          onPressed: () async {
                                            HapticFeedback.selectionClick();
                                            Get.offAll(MyHomePage(),
                                                transition:
                                                    Transition.cupertinoDialog,
                                                duration: Duration(seconds: 1));
                                            // Navigator.pushReplacement(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => MyHomePage(
                                            //               title: "Learning Helper",
                                            //             )));
                                          },
                                          child: Text("Yes")),
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
                                            offset: new Offset(2.5, 2.5),
                                            blurRadius: 2,
                                          )
                                        ],
                                      ),
                                      child: FlatButton(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 15, 0, 15),
                                          splashColor: blue,
                                          onPressed: () async {
                                            HapticFeedback.selectionClick();
                                            this.setState(() {
                                              play = !play;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text("No")),
                                    ),
                                  ],
                                ));
                      },
                      child: Text("Back")),
                ),
              ],
            ),
          ]))
    ]);
  }
}
