import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const Color PRIMARY_DARK = Color(0xff050646);
const Color PRIMARY_LIGHT = Color(0xff1D5295);

const Color MAIN_COLOR = Color(0xff26a69a);

// BASE URL
const String BASE_URL = 'Your api link';

class PUSHER {
  static const String KEY = 'Your Pusher key';
  static const String CLUSTER = 'Your cluster';
}

class ROUTE {
  static const String LOGIN = "/";
  static const String RULE = "/rule";
  static const String HOME = "/home";
}

class Remember {
  static const String login = 'login';
  static const String rule = 'rule';
  static const String username = 'username';
  static const String password = 'password';
}

class API {
  static const String LOGIN = "login";
  static const String RESET_PASSWORD = "reset";
  static const String UPDATE_PROFILE = "updateProfile";
  static const String REVEAL_ENTRY = "instant_reveal";
  static const String REDEEM_ENTRY = "redeemEntries";
}

class KEY {
  static const String CURRENT_USER = "current_user";
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

bool isInteger(num value) => value is int || value == value.roundToDouble();

showAlertDialog(BuildContext context, String title, String description) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(description),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showToast(BuildContext context, String message) {
  FlutterToast flutterToast = FlutterToast(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white70,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text(message),
      ],
    ),
  );

  flutterToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}
