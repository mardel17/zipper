import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zipper/view/home_page.dart';
import 'package:zipper/util/const.dart' as Const;
import 'package:zipper/util/globals.dart' as Globals;
import 'package:zipper/model/user.dart';
import 'package:zipper/widget/entry_field.dart';
import 'package:zipper/widget/entry_round.dart';
import 'package:zipper/widget/submit_button.dart';
import 'package:zipper/widget/submit_round.dart';
import 'package:zipper/widget/weather_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRemembered=false;
  bool isForgot = false;

  TextEditingController teUsername = new TextEditingController();
  TextEditingController tePassword = new TextEditingController();
  TextEditingController teEmail = new TextEditingController();

  Widget _logo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.center,
      child: Image.asset('assets/logo.png'),
    );
  }

  Widget _forgotPassword() {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        setState(() {
          isForgot = true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenSize.width / 36),
        alignment: Alignment.centerRight,
        child: Text("Forgot Password ?",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
      ),
    );
  }

  Future login() async {
    String username = teUsername.text.trim();
    String password = tePassword.text;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
    if (username.isEmpty) {
      Const.showAlertDialog(
          context, "ZipperGames", "Please input your username");
      return;
    }

    if (password.isEmpty) {
      Const.showAlertDialog(
          context, "ZipperGames", "Please input your password");
      return;
    }

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Please wait ... ");
    try {
      await progress.show();
      final http.Response response = await http.post(
          Const.BASE_URL + Const.API.LOGIN,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, dynamic>{'username': username, 'password': password}));

      await progress.hide();

      Map<String, dynamic> result = json.decode(response.body);

      if (response.statusCode == 200) {
        if (result['status'] == 'success') {
          Globals.token = result['token'];
          Globals.currentUser = User.fromJson(result['user_info']);

          final prefs = await SharedPreferences.getInstance();
          prefs.setString( Const.KEY.CURRENT_USER, jsonEncode(Globals.currentUser));
          prefs.setBool( Const.Remember.login,isRemembered);
          bool ruleRemember;
          try {
            bool rulered=prefs.getBool(Const.Remember.rule);
            ruleRemember = rulered ?? false;
          } catch (e) {
            ruleRemember = false;
          }
          if(ruleRemember==false){ Navigator.of(context).pushReplacementNamed(Const.ROUTE.RULE);}else{ Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => HomePage()));}

        } else {
          Const.showAlertDialog(context, 'ZipperGames', result['message']);
        }
      } else {
        Const.showAlertDialog(context, 'ZipperGames', 'Connection Error');
      }
    } catch (e) {
      await progress.hide();
      Const.showAlertDialog(context, 'ZipperGames', e.toString());
    }
  }

  Future resetPassword() async {
    String email = teEmail.text.trim();

    if (email.isEmpty) {
      Const.showAlertDialog(context, "ZipperGames", "Please input your Email");
      return;
    }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!emailValid) {
      Const.showAlertDialog(context, "ZipperGames", "Invalid Email Address");
      return;
    }

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Please wait ... ");
    try {
      await progress.show();
      final http.Response response =
          await http.post(Const.BASE_URL + Const.API.RESET_PASSWORD,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{'email': email}));

      await progress.hide();

      Map<String, dynamic> result = json.decode(response.body);

      if (response.statusCode == 200) {
        if (result['status'] == 'ok') {
          Const.showAlertDialog(
              context, 'ZipperGames', 'Please check your Email');
        } else {
          Const.showAlertDialog(context, 'ZipperGames', result['message']);
        }
      } else {
        Const.showAlertDialog(context, 'ZipperGames', 'Connection Error');
      }
    } catch (e) {
      await progress.hide();
      Const.showAlertDialog(context, 'ZipperGames', e.toString());
    }
  }

  Widget _portraitWidget() {
    final height = MediaQuery.of(context).size.height;
    var screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: height * .16),
        _logo(),
        SizedBox(height: screenSize.width / 18),
        (isForgot)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recover Password",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width / 22,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: screenSize.width / 36),
                  Text(
                    "Enter your Email and instructions will be sent to you!",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: screenSize.width / 36),
                  EntryRound(
                      title: 'Email',
                      teController: teEmail,
                      inputType: TextInputType.emailAddress),
                  SizedBox(height: screenSize.width / 18),
                  Row(
                    children: [
                      Flexible(
                        child: SubmitRound(
                          title: "RESET",
                          color: Color(0xff187DE4),
                          callback: resetPassword,
                        ),
                      ),
                      SizedBox(width: screenSize.width / 18),
                      Flexible(
                        child: SubmitRound(
                          title: "BACK",
                          color: Color(0xffEE9D01),
                          callback: () {
                            setState(() {
                              teEmail.clear();
                              isForgot = false;
                            });
                          },
                        ),
                      )
                    ],
                  )
                ],
              )
            : Column(
                children: [
                  EntryField(title: 'Username', teController: teUsername),
                  EntryField(
                      title: 'Password',
                      isPassword: true,
                      teController: tePassword),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Container(child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            isRemembered=!(isRemembered);
                          },
                          child: new Transform.scale(
                              scale:1,
                              child:new Checkbox(
                                  activeColor: Colors.white70,
                                  checkColor: Colors.blue,
                                  value: isRemembered,
                                  onChanged: (val) {
                                    setState(() {
                                      isRemembered = val;
                                    });}
                              )),),
                        Text("Remember",
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                      ],
                    )),
                    _forgotPassword(),
                  ],),
                  SizedBox(height: screenSize.width / 18),
                  SubmitButton(
                    title: "Sign In",
                    callback: () {
                      login();
                    },
                  ),
                ],
              ),
        SizedBox(height: screenSize.width / 36),
      ],
    );
  }

  Widget _landscapeWidget() {
    final height = MediaQuery.of(context).size.height;
    var screenSize = MediaQuery.of(context).size;

    return Row(
      children: [
        Flexible(child: Center(child: Container(padding:EdgeInsets.only(top:screenSize.width*0.06),margin:EdgeInsets.all(screenSize.width*0.05),child: _logo()))),
        SizedBox(width: 20),
        Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: height * .16),
            (isForgot)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recover Password",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width / 22,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: screenSize.width / 36),
                      Text(
                        "Enter your Email and instructions will be sent to you!",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: screenSize.width / 36),
                      EntryRound(
                          title: 'Email',
                          teController: teEmail,
                          inputType: TextInputType.emailAddress),
                      SizedBox(height: screenSize.width / 18),
                      Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: screenSize.width / 14,
                              child: SubmitRound(
                                title: "RESET",
                                color: Color(0xff187DE4),
                                callback: resetPassword,
                              ),
                            ),
                          ),
                          SizedBox(width: screenSize.width / 18),
                          Flexible(
                            child: SizedBox(
                              height: screenSize.width / 14,
                              child: SubmitRound(
                                title: "BACK",
                                color: Color(0xffEE9D01),
                                callback: () {
                                  setState(() {
                                    teEmail.clear();
                                    isForgot = false;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: screenSize.width/60,),
                      EntryField(title: 'Username', teController: teUsername),
                      EntryField(
                          title: 'Password',
                          isPassword: true,
                          teController: tePassword),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  isRemembered=!(isRemembered);
                                },
                                child: new Transform.scale(
                                    scale:1,
                                    child:new Checkbox(
                                        activeColor: Colors.white70,
                                        checkColor: Colors.blue,
                                        value: isRemembered,
                                        onChanged: (val) {
                                          setState(() {
                                            isRemembered = val;
                                          });}
                                    )),),
                              Text("Remember",
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                            ],
                          )),
                          _forgotPassword(),
                        ],),
                      SizedBox(height: screenSize.width / 40),
                      SubmitButton(
                        title: "Sign In",
                        callback: () {
                          login();
                        },
                      ),
                    ],
                  ),
            SizedBox(height: screenSize.width / 36),
          ],
        ))
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: height * .16),
        _logo(),
        SizedBox(height: screenSize.width / 18),
        (isForgot)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recover Password",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width / 22,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: screenSize.width / 36),
                  Text(
                    "Enter your Email and instructions will be sent to you!",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: screenSize.width / 36),
                  EntryRound(
                      title: 'Email',
                      teController: teEmail,
                      inputType: TextInputType.emailAddress),
                  SizedBox(height: screenSize.width / 18),
                  Row(
                    children: [
                      Flexible(
                        child: SubmitRound(
                          title: "RESET",
                          color: Color(0xff187DE4),
                          callback: resetPassword,
                        ),
                      ),
                      SizedBox(width: screenSize.width / 18),
                      Flexible(
                        child: SubmitRound(
                          title: "BACK",
                          color: Color(0xffEE9D01),
                          callback: () {
                            setState(() {
                              teEmail.clear();
                              isForgot = false;
                            });
                          },
                        ),
                      )
                    ],
                  )
                ],
              )
            : Column(
                children: [
                  EntryField(title: 'Username', teController: teUsername),
                  EntryField(
                      title: 'Password',
                      isPassword: true,
                      teController: tePassword),
                  _forgotPassword(),
                  SizedBox(height: screenSize.width / 18),
                  SubmitButton(
                    title: "Sign In",
                    callback: () {
                      login();
                    },
                  ),
                ],
              ),
        SizedBox(height: screenSize.width / 36),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff175291), Color(0xff66AAD2)])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              WeatherField(),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width / 18),
                child: SingleChildScrollView(
                    child: OrientationBuilder(builder: (context, _) {
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait) {
                    return _portraitWidget();
                  } else {
                    return _landscapeWidget();
                  }
                })),
              ),
            ],
          )),
    );
  }
}
