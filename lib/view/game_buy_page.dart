import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:zipper/model/user.dart';

import 'package:zipper/util/const.dart' as Const;
import 'package:zipper/widget/entry_round.dart';
import 'package:zipper/widget/key_round.dart';
import 'package:zipper/widget/submit_button.dart';
import 'package:zipper/widget/game_submit_round.dart';

import 'package:zipper/util/globals.dart' as Globals;

class game_BuyPage extends StatefulWidget {
  game_BuyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<game_BuyPage> {
  TextEditingController teTotal = TextEditingController();
  TextEditingController tePaying = TextEditingController();
  TextEditingController teFree = TextEditingController();

  int freeEntries = 0;

  Future redeemEntry(double paying) async {
    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Please wait ... ");
    try {
      await progress.show();
      final http.Response response =
          await http.post(Const.BASE_URL + Const.API.REDEEM_ENTRY,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${Globals.token}'
              },
              body: jsonEncode(<String, dynamic>{'value': paying}));

      await progress.hide();
      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (response.statusCode == 200) {
        if (result['status'] == 'success') {
          Const.showToast(context, "Success");
          setState(() {
            Globals.currentUser = User.fromJson(result['user_info']);
          });
          Navigator.of(context).pop(true);
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

  @override
  void initState() {
    super.initState();
    teTotal.text = Globals.currentUser.earnings.toString();

    tePaying.addListener(() {
      final text = tePaying.text;
      tePaying.value = tePaying.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  void calculateEntries(int value) {
    switch (value) {
      case 100:
        freeEntries = freeEntries * 100;
        break;

      case 500:
        freeEntries += 500;
        break;

      case 1000:
        freeEntries += 1000;
        break;

      case 2000:
        freeEntries += 2000;
        break;

      case 10000:
        freeEntries = (Globals.currentUser.earnings * 100).toInt();
        break;

      default:
        freeEntries = freeEntries * 10 + (value * 100);
        break;
    }

    updateEntries();
  }

  void clearEntries() {
    freeEntries = 0;
    setState(() {
      teFree.clear();
      tePaying.clear();
    });
  }

  void updateEntries() {
    if (freeEntries > Globals.currentUser.earnings * 100) {
      freeEntries = (Globals.currentUser.earnings * 100).toInt();
    }

    setState(() {
      teFree.text = freeEntries.toString();

      double paying = freeEntries / 100.0;
      if (Const.isInteger(paying)) {
        tePaying.text = paying.toInt().toString();
      } else {
        tePaying.text = paying.toString();
      }
    });
  }

  Widget _payingWidget() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenSize.width / 60),
      height: screenSize.width / 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(screenSize.width / 92)),
        color: Color(0xffffffff),
      ),
      child: TextField(
        readOnly: true,
        controller: tePaying,
        onChanged: (value) {
          if (Const.isNumeric(value)) {
            freeEntries = (double.parse(value) * 100).toInt();
            updateEntries();
          } else {
            clearEntries();
            Const.showToast(context, 'Please input numerical values');
          }
        },
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: screenSize.width / 14,right: screenSize.width / 14,bottom: screenSize.width / 100),
            hintText: 'Amount'),
      ),
    );
  }

  Widget _numberWidget() {
    var screenSize = MediaQuery.of(context).size;
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '7',
                  callback: () {
                    calculateEntries(7);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '8',
                  callback: () {
                    calculateEntries(8);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '9',
                  callback: () {
                    calculateEntries(9);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: GameSubmitRound(
                  title: 'ALL',
                  color: Color(0xff5B4BC7),
                  callback: () {
                    calculateEntries(10000);
                  })),
        ],
      ),
      SizedBox(height: screenSize.width / 90),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '4',
                  callback: () {
                    calculateEntries(4);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '5',
                  callback: () {
                    calculateEntries(5);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '6',
                  callback: () {
                    calculateEntries(6);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: GameSubmitRound(
                  title: '\$20',
                  color: Color(0xff1976D2),
                  callback: () {
                    calculateEntries(2000);
                  })),
        ],
      ),
      SizedBox(height: screenSize.width / 90),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '1',
                  callback: () {
                    calculateEntries(1);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '2',
                  callback: () {
                    calculateEntries(2);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '3',
                  callback: () {
                    calculateEntries(3);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: GameSubmitRound(
                  title: '\$10',
                  color: Color(0xff1976D2),
                  callback: () {
                    calculateEntries(1000);
                  })),
        ],
      ),
      SizedBox(height: screenSize.width / 90),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: screenSize.width / 6,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '0',
                  callback: () {
                    calculateEntries(0);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: KeyRound(
                  title: '00',
                  callback: () {
                    calculateEntries(100);
                  })),
          SizedBox(
              width: screenSize.width / 12,
              height: screenSize.width / 18,
              child: GameSubmitRound(
                  title: '\$5',
                  color: Color(0xff1976D2),
                  callback: () {
                    calculateEntries(500);
                  })),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(false);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.4),
        body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                  left: screenSize.width / 12,
                  right: screenSize.width / 12,
                  top: screenSize.width / 40,
                  bottom: screenSize.width / 40),
              padding: EdgeInsets.only(
                  left: screenSize.width / 22,
                  right: screenSize.width / 22,
                  top: screenSize.width / 40,
                  bottom: screenSize.width / 40),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff050646),
                        Color(0xff1D5295),
                      ]),
                  borderRadius:
                      BorderRadius.all(Radius.circular(screenSize.width / 18))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Buy Products',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width / 35),
                        )),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            size: screenSize.width / 25,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: screenSize.width * 0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenSize.width / 80),
                              Text(
                                'Total Winnings value',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width / 35),
                              ),
                              Container(
                                height: screenSize.width / 12,
                                child: EntryRound(
                                    title: '0',
                                    editable: false,
                                    teController: teTotal),
                              ),
                              Text(
                                'Paying Winnings value',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width / 35),
                              ),
                              Row(children: [
                                Expanded(child: _payingWidget()),
                                SizedBox(width: screenSize.width / 100),
                                SizedBox(
                                  width: screenSize.width / 12,
                                  child: GameSubmitRound(
                                      title: "ERASE",
                                      color: Color(0xffEF5350),
                                      callback: clearEntries),
                                ),
                              ]),
                              Text(
                                'Free Awarded Entries',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width / 35),
                              ),
                              Container(
                                height: screenSize.width / 12,
                                child: EntryRound(
                                    title: '',
                                    editable: false,
                                    teController: teFree),
                              ),
                              SizedBox(height: screenSize.width / 36),
                            ],
                          ),
                        ),
                        SizedBox(width: screenSize.width / 25),
                        Column(
                          children: [
                            _numberWidget(),
                            SizedBox(height: screenSize.width / 70),
                            Container(
                              width: screenSize.width / 3,
                              child: Text(
                                'Use your current winnings to buy more product and be entitled to receive additional free entries.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: screenSize.width / 2,
                      child: SubmitButton(
                        title: 'Buy More Products',
                        color: Color(0xffEF5A02),
                        callback: () {
                          if (freeEntries > 0) {
                            redeemEntry(freeEntries / 100.0);
                          }
                        },
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
