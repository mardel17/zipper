import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zipper/util/const.dart' as Const;
import 'package:zipper/view/login_page.dart';
import 'package:zipper/view/rule_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zipper/view/home_page.dart';
import 'package:zipper/model/user.dart';
import 'package:zipper/util/globals.dart' as Globals;
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  bool isRemember = await isLoged();
  runApp(MyApp(isRemember: isRemember));
}

Future<bool> isLoged() async {
  bool isLogged;

  final prefs = await SharedPreferences.getInstance();
  try {
    bool idledVal = prefs.getBool(Const.Remember.login);
    isLogged = idledVal ?? false;
  } catch (e) {
    isLogged = false;
  }

  if (isLogged) {
    String username=prefs.getString('username');
    String password=prefs.getString('password');
    final http.Response response = await http.post(
        Const.BASE_URL + Const.API.LOGIN,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{'username': username, 'password': password}));
    Map<String, dynamic> result = json.decode(response.body);
    try {
      if(response.statusCode==200){
        if (result['status'] == 'success') {
          Globals.token = result['token'];
          Globals.currentUser = User.fromJson(result['user_info']);
        }
      }

    } catch (e) {

    }
  }
  return isLogged;
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title, @required this.isRemember}) : super(key: key);

  final String title;
  final bool isRemember;

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        title: 'EMI',
        theme: ThemeData(
          primaryColor: Const.PRIMARY_DARK,
          textTheme: GoogleFonts.robotoTextTheme(textTheme).copyWith(
              bodyText1:
              GoogleFonts.montserrat(textStyle: textTheme.bodyText1)),
        ),
        debugShowCheckedModeBanner: false,
        // home: WelcomePage(),
        initialRoute: widget.isRemember ? Const.ROUTE.HOME : Const.ROUTE.LOGIN,
        // initialRoute: Const.ROUTE.LOGIN,
        routes: {
          Const.ROUTE.HOME: (context) => HomePage(),
          Const.ROUTE.LOGIN: (context) => LoginPage(),
          Const.ROUTE.RULE: (context) => RulePage(),
          // Const.ROUTE.SIGNUP: (context) => SignUpPage(),
          // Const.ROUTE.HOME: (context) => HomePage()
        });
  }
}