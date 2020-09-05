import 'package:Learning_Helper/dbandmodels/Helper.dart';
import 'package:Learning_Helper/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'stopwatch.dart';

class Update extends StatefulWidget {
  final Map data;

  final List hellu;
  Update({Key key, this.data, this.hellu}) : super(key: key);
  @override
  UpdateState createState() => UpdateState();
}

class UpdateState extends State<Update> {
  String supdate = "";
  String err;
  void refresh() {
    setState(() {});
    print('ok');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data["subject"] is String) {
      supdate = widget.data["subject"];
      return Scaffold(
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
                style: TextStyle(
                  color:blue
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Divider(
              color: Colors.black,
              height: 25,
            ),
            TextFormField(
              validator: (value) {
                print(value);
                if (value.isEmpty) {
                  print("hi");
                  return "Subject must not empty!";
                }
                return null;
              },
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  labelText: "Subject",
                  errorText: err,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: blue),
                  )),
              onChanged: (value) {
                supdate = value;
                if (supdate == "")
                  this.setState(() {
                    err = "Subject must not empty!";
                  });
                else
                  this.setState(() {
                    err = null;
                  });
              },
              initialValue: widget.data["subject"],
            ),
            StopWatch(
              parent: this,
              hellu: widget.hellu,
            ),
          ],
        ),
      );
    } else if (widget.data["subject"] == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Divider(
              color: Colors.black,
              height: 25,
            ),
            TextFormField(
              autofocus: true,
              validator: (value) {
                print(value);
                if (value.isEmpty) {
                  print("hi");
                  return "Subject must not empty!";
                }
                return null;
              },
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  labelText: "Subject",
                  errorText: err,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: blue),
                  )),
              onChanged: (value) {
                supdate = value;
                if (supdate == "")
                  this.setState(() {
                    err = "Subject must not empty!";
                  });
                else
                  this.setState(() {
                    err = null;
                  });
              },
            ),
            Divider(
              color: Colors.black,
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                color: blacks,
                // gradient: new LinearGradient(
                //     colors: [blue, Colors.black],
                //     begin: Alignment.centerLeft,
                //     end: new Alignment(0.5, -1)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  new BoxShadow(
                    color: blue,
                    offset: new Offset(2.5, 2.5),
                    blurRadius: 2,
                  )
                ],
              ),
              child: supdate == ""
                  ? null
                  : FlatButton(
                      onPressed: supdate == ""
                          ? null
                          : () async {
                            HapticFeedback.selectionClick();
                              await DbHelp.instance.inserts({
                                DbHelp.subject: supdate,
                                DbHelp.hour: 0,
                                DbHelp.minute: 0,
                              });

                              Navigator.pop(context);
                            },
                      child: Text("Add")),
            ),
          ],
        ),
      );
    }
  }
}
