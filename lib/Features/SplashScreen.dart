import 'package:Learning_Helper/dbandmodels/Helper.dart';
import 'package:Learning_Helper/main.dart';
import 'package:Learning_Helper/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreen({Key key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;
  void initState() {
    super.initState();
    
    rotationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    rotationController.forward();
    Future.delayed(Duration(seconds: 3),() async{
      dynamic hi = await DbHelp.instance.select();
      int count = hi.length;
      Get.off(MyHomePage(countdata: count,));
      rotationController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 8.0).animate(rotationController),
            child: Image.asset(
              // 'assets/image/3667eb23-a854-4275-b95e-2d956ed4ca90_200x200.png',
              'assets/image/cookie.png',
              scale: 1.5,
            ),
          ),
          Text(
            "Biscotti",
            style: TextStyle(
                color: blue,
                fontSize: 30,
                letterSpacing: 10,
                shadows: [
                  Shadow(
                    offset: Offset(0, 7),
                    blurRadius: 6.0,
                    color: blue,
                  ),
                ]),
          ),
        ],
      )),
    );
  }
}
