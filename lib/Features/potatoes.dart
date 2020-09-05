import 'package:Learning_Helper/dbandmodels/Helper.dart';

Future<bool> exceed(int totalhour, int totalmin) async {
  dynamic b = await DbHelp.instance.localselects();
  print(totalhour.toString() + totalmin.toString() + "hellu");
  print(b[0]["totalhour"].toString() + b[0]["totalmin"].toString() + "hellu");
  if (totalhour < b[0]["totalhour"]) {
    return false;
  } else if (totalhour == b[0]["totalhour"]) {
    if (totalmin <= b[0]["totalmin"]) {
      return false;
    } else {
      return true;
    }
  } else {
    return true;
  }
  
}


