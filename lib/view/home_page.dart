import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:zipper/util/globals.dart' as Globals;
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:zipper/widget/submit_round.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zipper/util/const.dart' as Const;
import 'package:zipper/model/user.dart';
import 'package:zipper/view/buy_page.dart';
import 'package:zipper/view/game_page.dart';
import 'package:zipper/widget/app_drawer.dart';
import 'package:zipper/widget/firework_field.dart';
import 'package:zipper/widget/game_widget.dart';
import 'package:zipper/widget/submit_shadow.dart';
import 'package:zipper/widget/reveal_button.dart';
import 'package:zipper/widget/port_reveal_button.dart';
import 'package:zipper/view/game_buy_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isNeed = false;
  FireworkField _fireworkField;
  String html = """
        <p>
            <strong>NO PURCHASE OF BLUMAX  COMPUTER WORK STATION TIME,
                OR ANY OTHER PRODUCT OR SERVICE IS REQUIRED TO PARTICIPATE IN THIS PROMOTIONAL GAME.<br>PARTICIPATION IS FREE. PURCHASE OF ANY PRODUCT OR SERVICE WILL
                NOT INCREASE YOUR ODDS OF WINNING.</strong><br><br>1. <strong>SPONSORSHIP.</strong> The name and address of the sponsor of this promotional game (the "sponsor") is posted with the paper version
            of these Official Rules at the store where you are partecipating in this free promotion.
            <br><br>
            2.<strong> ELIGIBILITY. </strong>This promotional game is open to legal residents of the 50 states of the United States and of the District of Columbia who are 18 years of age or older
            at the time of participation and who are not ineligible as set out in these Official Rules. Void wherever prohibited by law. Employees (and members of employees' immediate families
            and residents in their households) of the S cardponsor and the Sponsor's suppliers are not eligible to play or win.
            <br><br>
            3.<strong> HOW TO ENTER. TO ENTER BY PURCHASE</strong> You may purchase any of (1) BluMax computer workstation time at the Sponsor's store (2) Any other product sold at the sponsor store.
            For each dollar of such purchase you will be awarded one entry (one hundred credits) to enter the promotional game.
            Also, promotional game participation points are awarded upon your purchase of certain of the goods for sale at the Sponsor store as indicated by postings at the point of sale.
            <br><strong>TO ENTER WITHOUT PURCHASE: </strong>(a) in person at the store ask the Sponsor's point of sale staff for a free daily entry, limited to one entry (one hundred points)
            per person per day and usable only at the premises of the Sponsor set out in paragraph 1 of these rules; or (b) ask the point-of-sale clerk for an official free entry request form,
            legibly hand print all of the information requested on the form and follow the mailing instructions on the form;or (c) on a postcard or sheet of white paper no smaller than three
            inches by five inches (3" x 5") hand print your name, address, city, state, zip code, age, the date you are preparing your request and the name and store address of the Sponsor.
            Mail the official free entry request form or handwritten free entry request, with the envelope or postcard address handwritten and the return address also handwritten, to:
            <br><br><strong>Official Free Entry Request</strong>
            <br><strong>Address......
            </strong><br><br>
            No return envelope is required. Limit of one free entry (100 points) per complying stamped (postage prepaid) hand-written outer envelope or complying stamped
            (postage prepaid) hand-written postcard. Each qualifying request received 06/21/2021 will be awarded free entry credits equivalent to the free entry credits that normally accompany a purchase of \$1.00 worth of COMPUTER WORKSTATION TIME  Free entry requests will be disqualified for any of: (1) ineligibility, (2) inclusion with
            the free entry request of any other correspondence, promotional materials or other materials, (3) lost, late, damaged or misdirected or postage due requests and (4)
            requests that in the opinion of the Sponsor are machine-generated in whole or in part, including but not limited to the stamped outer envelope or postcard. The
            decision of the Sponsor regarding eligibility or disqualification of free entry requests received, will be final. A free entry will not entitle the person requesting it or any
            other person, to music downloads, use of the computer work station, telephone talk time or any other product or service that may be purchased from the Sponsor. Free
            entry requests received by the Sponsor become the Sponsor’s property upon receipt. Ineligible and noncomplying requests will not be acknowledged.
            <br><br>
            4.<strong> HOW TO PLAY. </strong>Participation in the promotional game, whether by free entry or by purchase, is limited to the premises of the Sponsor identified in paragraph 1 of these
            rules. The Sponsor's point-of-sale clerk will tell you what (if anything) you have won and will then pay to you in cash anything that you have won. If instead you want to
            view your participation results on the monitor screen of the computer work station the point of sale clerk will instruct you how to use the electronic equipment to do so.
            If you choose to use the electronic equipment to view the results of your entries, key into the computer terminal the account number assigned to you. If a card swiper is
            provided at the computer work station and you have been issued an account number.
            When you enter your account number you will see on the
            monitor, two account displays. One points account display is clearly marked as "ENTRIES TO REVEAL." This discloses the number of game promotion points that you have remaining in your account to
            reveal using the monitor displays. The other is clearly marked, as, "Winnings AWARDED." If you have entered the promotional game by purchasing telephone talk time, the use of promotional game
            entry points and time on the computer work station spent revealing their award values will not reduce the telephone talk time that you have purchased. If you have purchased computer work station time,
            the use of promotional game entry points and time on the computer work station spent revealing their values will not reduce the time available to use the computer work station. If you have purchased music
            downloads or tangible merchandise, your entitlement to these purchased items will not be affected by time spent revealing the award value of your game promotion points.
            Whether you have entered for free or by purchase, you can not use promotional Winningss to play or replay the promotional game. Cash promotional awards and other promotional awards are offered at the rate
            of one cent per award credit that you receive. To collect at any time, tell the participating retailer what you have won. On verification of that amount the participating retailer will pay to you in
            currency, stored value cards or store merchandise, having a value in each case of the amount that you have won. The right to receive promotional Winningss cannot be assigned or transferred by the
            participant who is entitled to the Winningss.
            <br><br>
            5. <strong>HOW WINNERS ARE SELECTED. </strong>Participation outcomes are drawn from a single finite deal of 1,431,690.00 electronic game pieces.
            Each electronic game piece has an assigned value, as low as zero and as high as \$ 4,000.00 .On each draw from the finite deal the Sponsor's computer system will select from the finite deal of electronic game pieces, one that represents the result of that draw.
            Upon such selection, the electronic game piece is removed from the deal and is not used again. The value (if any) of the electronic game piece selected will be added to the promotional award display
            on the monitor of the computer terminal that you are using.
            <br><br>
            6. <strong>ODDS OF WINNING. </strong>On each draw the odds are one out of 2.70 that you will win something. The highest promotional Winnings value associated with an electronic game piece is \$ 4,000.00 On a draw of a single game piece the odds of drawing one with this value are 1 out of 477,230.00 . You can draw up to 100 entries at one time. There are three ways that you can obtain a more detailed and complete statement of the odds of winning:
            (1) request a written summary and disclosure of the winning odds by writing to the Sponsor at Address......  or (2) request the written summary and disclosure in paper form of the winning odds form at the Sponsor's store, or (3)
            <br><br>
            7. <strong>OTHER TERMS AND CONDITIONS OF THE OFFICIAL RULES. </strong>This promotional game begins on 10/24/2020 and ends on the earliest of (a) 06/21/2021 or (b) when the deal of electronic game pieces is exhausted or (c) when terminated by the Sponsor for the reasons stated below. The Sponsor reserves the
            right to modify and/or terminate this sweepstakes promotional game and to take such other measures the Sponsor may deem necessary to appropriate, in its sole
            discretion to preserve the integrity of the sweepstakes promotional game or in the event that it or associated practices or equipment become corrupted, technically or
            otherwise. In such event, Winningss will be awarded only from entries received prior to the date of termination or modification. Participating entrants release the Sponsor,
            together with all other businesses involved in this promotional game, as well as the employees, officers and directors of each, of all claims and liability related to
            participation in this promotional game. Any promotional game notice, entry form or other writing, including writings in electronic form, that contains an error (printing,
            human, technical or other) shall be deemed null and void. Technical malfunction of the electronic equipment associated with this promotional game, voids all play on it.
            Winners may be required, at the sole discretion of the Sponsor, to sign and return an affidavit of eligibility/liability release and where legally permissible, a publicity
            release, as a condition precedent to the receipt of any Winnings to be awarded. All winners are subject to disclosure of their winnings and identifying information, to the
            extent such disclosure is required by law or provided for in these Official Rules. Regardless of how winners use Winningss awarded to them, all such awards are taxable
            income to the participant. Participants are responsible to pay all income and other taxes due in respect of any Winnings that they receive. If the Sponsor is required to
            report the value of promotional awards to the Internal Revenue Service on IRS Form 1099-MISC, the Sponsor reserves the right to condition payment or delivery of such
            awards on your disclosure of such information as may be necessary (including your social security account number) to enable the Sponsor to make such reports as may
            be required by law. Except where prohibited by law, all winners consent to the use of their names, home town, Winningss won and likenesses for promotional purposes on
            behalf of the sponsor and the participating retailer. All disputes and claims arising out of or relating to this promotional game shall be determined according to the laws
            of the state in which the Sponsor's retail premises is located, without regard to such state's conflict of law principles. All participating entrants, by their participation,
            consent to the personal jurisdiction of the U.S. federal and state courts located in that state and agree that such courts have exclusive jurisdiction over all such disputes.
            All causes of action in any way arising out of or connected with this sweepstakes promotional game shall be resolved individually without resort to any form of class
            action litigation; and any claims, judgments and awards shall be limited to actual outof-pocket expenses incurred. If the law entitles you or the public to a list of winners,
            then for a list of winners of Winningss of amounts specified in the applicable law, send a written request to: Winners List Request, PO Box Address......
            <br><br>
            8. <strong>PRIVACY POLICY. </strong> The Sponsor respects every patron's right to privacy and the importance of protecting information collected about them. The Sponsor, has
            adopted a company-wide privacy policy which guides how the Sponsor will store and use the personal information which patrons provide in connection with their
            participation in the promotional game. The Sponsor adheres to the safe-harbor principles that have been established by federal law. Any participant who has
            questions or comments about the Sponsor’s privacy policy may present the inquiry by writing to: Privacy Policy Administrator, PO Box Address......  The Sponsor's store address must be stated in the inquiry. This policy applies only to information collected by the Sponsor in connection with
            patrons' participation in the game promotion. Personal information is information which identifies the patron and may be used to contact the patron. The Official
            Rules of this game promotion provide that children under eighteen years of age are ineligible to participate or to win Winningss from their participation in the game.
            <strong>CHILDREN MUST NEVER SUPPLY THEIR NAMES OR OTHER IDENTIFYING INFORMATION WITHOUT THEIR PARENTS' WRITTEN PERMISSION.</strong> No information should be provided to
            the Sponsor by or regarding children. If for any reason any person is concerned about a child’s personal identifying information having been supplied, such person should
            contact the Sponsor by writing to the address set out above and specifying the store address. In response to the inquiry the Sponsor will review and remove the child's information as appropriate. In any
            event the Sponsor does not knowingly disclose personal information about children. The personal information provided by patrons will allow the Sponsor and participating
            retailers to make official reports required by law and to cooperate with government agencies and processes. The Sponsor will use the information for no other purposes.
        </p>
      """;
  final GlobalKey<FireworkFieldState> _fireworkState =
      GlobalKey<FireworkFieldState>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _fireworkField = FireworkField(key: _fireworkState);
  }

  Future revealEntry(int reveal) async {
    final prefs = await SharedPreferences.getInstance();
    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Please wait ... ");
    try {
      await progress.show();
      final http.Response response =
          await http.post(Const.BASE_URL + Const.API.REVEAL_ENTRY,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${Globals.token}'
              },
              body: jsonEncode(<String, dynamic>{'entries': reveal}));

      await progress.hide();
      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (response.statusCode == 200) {
        if (result['status'] == 'OK') {
          Const.showToast(
              context, "award: ${(result['award']).toStringAsFixed(2)}");
          final http.Response responseUser = await http.post(
              Const.BASE_URL + Const.API.LOGIN,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'username': prefs.getString('username'),
                'password': prefs.getString('password')
              }));
          Map<String, dynamic> resultUser = json.decode(responseUser.body);

          if (responseUser.statusCode == 200) {
            if (resultUser['status'] == 'success') {
              setState(() {
                Globals.currentUser = User.fromJson(resultUser['user_info']);
              });
            }
          }
        } else {
          Const.showAlertDialog(context, 'ZipperGames', result['message']);
        }
      } else {
        Const.showAlertDialog(context, 'ZipperGames', 'Connection Error');
      }
    } catch (e) {
      await progress.hide();
      Const.showAlertDialog(
          context, 'ZipperGames', "Sorry , but your entry is not enough now.");
    }
  }

  void showpromotionRuleDialog() async {
    var screenSize = MediaQuery.of(context).size;
    final prefs = await SharedPreferences.getInstance();
    showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
              scale: a1.value,
              child: Center(
                  child: Material(
                      color: Colors.transparent,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(screenSize.width / 92)),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Promotions Rules",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: screenSize.width / 36),
                            Flexible(
                              child: WebView(
                                initialUrl: 'about:blank',
                                onWebViewCreated: (controller) {
                                  controller.loadUrl(Uri.dataFromString(html,
                                          mimeType: 'text/html',
                                          encoding: Encoding.getByName('utf-8'))
                                      .toString());
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Flexible(
                                    child: SubmitRound(
                                  title: "No, thank you",
                                  color: Color(0xffFF0C0C),
                                  callback: () {
                                    prefs.setBool(Const.Remember.rule, false);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HomePage()));
                                  },
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                    child: SubmitRound(
                                  title: "I agree with the promotion rules",
                                  color: Color(0xff44D410),
                                  callback: () {
                                    prefs.setBool(Const.Remember.rule, true);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HomePage()));
                                  },
                                )),
                              ],
                            ),
                          ],
                        ),
                      ))));
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Center(
              child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(screenSize.width / 92)),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Promotions Rules",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenSize.width / 36),
                        Flexible(
                          child: WebView(
                            initialUrl: 'about:blank',
                            onWebViewCreated: (controller) {
                              controller.loadUrl(Uri.dataFromString(html,
                                      mimeType: 'text/html',
                                      encoding: Encoding.getByName('utf-8'))
                                  .toString());
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                                child: SubmitRound(
                              title: "No, thank you",
                              color: Color(0xffFF0C0C),
                              callback: () {
                                prefs.setBool(Const.Remember.rule, false);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomePage()));
                              },
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: SubmitRound(
                              title: "I agree with the promotion rules",
                              color: Color(0xff44D410),
                              callback: () {
                                prefs.setBool(Const.Remember.rule, true);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomePage()));
                              },
                            )),
                          ],
                        ),
                      ],
                    ),
                  )));
        });
  }

  void showRevealConfirmDialog() {
    showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
              scale: a1.value,
              child: Center(
                  child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 250,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff050646),
                                Color(0xff1D5295),
                              ]),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                color: Color(0xff1316e5),
                              ),
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Warnings',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 20),
                                  )),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 24,
                                      color: Colors.white54,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 20),
                              child: Text(
                                'Confirm to be agree to immediately display Winnings of these amount of entries,please!',
                                style: TextStyle(
                                    height: 2,
                                    color: Colors.white,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                      ))));
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Center(
              child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 250,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff050646),
                            Color(0xff1D5295),
                          ]),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            color: Color(0xff1316e5),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Warnings',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 20),
                              )),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 24,
                                  color: Colors.white54,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Confirm to be agree to immediately display Winnings of these amount of entries,please!',
                            style: TextStyle(
                                height: 2, color: Colors.white, fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }

  void port_showRevealDialog() {
    var screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isAgree = false;
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(screenSize.width / 18))),
                content: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "By using the instant revealer, I acknowledge that I am choosing to immediately view the results of my sweepstakes entries without any game simulation.",
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                    SizedBox(height: screenSize.width / 24),
                    SizedBox(
                        width: screenSize.width / 3,
                        height: screenSize.width / 9,
                        child: port_RevealButton(
                            title: 'Reveal 20',
                            callback: () {
                              if (isAgree == true) {
                                Navigator.of(context).pop();
                                revealEntry(20);
                              } else {
                                showRevealConfirmDialog();
                              }
                            })),
                    SizedBox(height: screenSize.width / 24),
                    SizedBox(
                        width: screenSize.width / 3,
                        height: screenSize.width / 9,
                        child: port_RevealButton(
                            title: 'Reveal 40',
                            callback: () {
                              if (isAgree == true) {
                                Navigator.of(context).pop();
                                revealEntry(40);
                              } else {
                                showRevealConfirmDialog();
                              }
                            })),
                    SizedBox(height: screenSize.width / 24),
                    SizedBox(
                        width: screenSize.width / 3,
                        height: screenSize.width / 9,
                        child: port_RevealButton(
                            title: 'Reveal 100',
                            callback: () {
                              if (isAgree == true) {
                                Navigator.of(context).pop();
                                revealEntry(100);
                              } else {
                                showRevealConfirmDialog();
                              }
                            })),
                    SizedBox(height: screenSize.width / 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                isAgree = !(isAgree);
                              },
                              child: new Transform.scale(
                                  scale: 1,
                                  child: new Checkbox(
                                      checkColor: Colors.green,
                                      activeColor: Colors.white,
                                      value: isAgree,
                                      onChanged: (val) {
                                        setState(() {
                                          isAgree = val;
                                        });
                                      })),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                        Flexible(
                          child: Text(
                            "I agree to immediately display the results of the entries chosen.",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: screenSize.width / 24),
                          ),
                        ),
                      ],
                    )
                  ],
                )));
          },
        );
      },
    );
  }

  void showRevealDialog_landscape() {
    var screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isAgree = false;
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(screenSize.width / 18))),
                content: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenSize.width / 30),
                    Text(
                      "By using the instant revealer, I acknowledge that I am choosing to immediately view the results of my sweepstakes entries without any game simulation.",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenSize.width / 40),
                    ),
                    SizedBox(height: screenSize.width / 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: screenSize.width / 6,
                            height: screenSize.width / 15,
                            child: RevealButton(
                                title: 'Reveal 20',
                                callback: () {
                                  if (isAgree == true) {
                                    Navigator.of(context).pop();
                                    revealEntry(20);
                                  } else {
                                    showRevealConfirmDialog();
                                  }
                                })),
                        SizedBox(
                            width: screenSize.width / 6,
                            height: screenSize.width / 15,
                            child: RevealButton(
                                title: 'Reveal 40',
                                callback: () {
                                  if (isAgree == true) {
                                    Navigator.of(context).pop();
                                    revealEntry(40);
                                  } else {
                                    showRevealConfirmDialog();
                                  }
                                })),
                        SizedBox(
                            width: screenSize.width / 6,
                            height: screenSize.width / 15,
                            child: RevealButton(
                                title: 'Reveal 100',
                                callback: () {
                                  if (isAgree == true) {
                                    Navigator.of(context).pop();
                                    revealEntry(100);
                                  } else {
                                    showRevealConfirmDialog();
                                  }
                                })),
                      ],
                    ),
                    SizedBox(height: screenSize.width / 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            isAgree = !(isAgree);
                          },
                          child: new Transform.scale(
                              scale: 1,
                              child: new Checkbox(
                                  checkColor: Colors.green,
                                  activeColor: Colors.white,
                                  value: isAgree,
                                  onChanged: (val) {
                                    setState(() {
                                      isAgree = val;
                                    });
                                  })),
                        ),
                        Flexible(
                          child: Text(
                            "I agree to immediately display the results of the entries chosen.",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: screenSize.width / 40),
                          ),
                        ),
                      ],
                    )
                  ],
                )));
          },
        );
      },
    );
  }

  Widget _gameWidget() {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          crossAxisCount:
              (MediaQuery.of(context).orientation == Orientation.portrait)
                  ? 2
                  : 3,
          children: [
            GameWidget(
                asset: 'assets/1.png',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/soccer/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/2.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/slot-machine-the-fruits/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/3.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/slot-machine-mr-chicken/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/4.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/scratch-fruit/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/5.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/greyhound-racing/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/6.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/horse-racing/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            GameWidget(
                asset: 'assets/7.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/keno/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/8.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/high-or-low/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/9.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/slot-arabian/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/10.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/slot-ramses/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/11.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/bingo/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/12.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/slot-machine-space-adventure/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/13.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/baccarat/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/14.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/plinko/game_mobile/index.html',
                            screenmode: false,
                          )));
                }),
            GameWidget(
                asset: 'assets/15.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/3d-blackjack/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/16.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/caribbean-stud-poker/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/17.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/wheel-of-fortune/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),
            GameWidget(
                asset: 'assets/18.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/3d-soccer/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),

            GameWidget(
                asset: 'assets/19.jpg',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/joker-poker/game_mobile/index.html',
                            screenmode: true,
                          )));
                }),

            GameWidget(
                asset: 'assets/20.png',
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GamePage(
                            url:
                                'http://your-link/games/lucky-slot-machine/Unminified_mobile/index.html',
                            screenmode: true,
                          )));
                }),
          ],
        );
      },
    );
  }

  Widget _entryWidget() {
    return Row(
      children: [
        Text('ENTRIES    ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400)),
        SizedBox(width: 10),
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Color(0xffAAB8CE),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4))),
                child: Text(Globals.currentUser.entries.toString(),
                    style: TextStyle(color: Color(0xff758488))),
              ),
            ),
            InkWell(
              onTap: showBuyPage,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Color(0xff1976D2),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4))),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            )
          ],
        ))
      ],
    );
  }

  Widget _landscape_entryWidget() {
    return Row(
      children: [
        Text('ENTRIES    ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400)),
        SizedBox(width: 10),
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Color(0xffAAB8CE),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4))),
                child: Text(Globals.currentUser.entries.toString(),
                    style: TextStyle(color: Color(0xff758488))),
              ),
            ),
            InkWell(
              onTap: showlandscapeBuyPage,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Color(0xff1976D2),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4))),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            )
          ],
        ))
      ],
    );
  }

  Widget _winningWidget() {
    return Row(
      children: [
        Text('WINNINGS',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400)),
        SizedBox(width: 10),
        Expanded(
            child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4))),
              child: Icon(
                Icons.attach_money,
                size: 24,
              ),
            ),
            Expanded(
              child: Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Color(0xffAAB8CE),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4))),
                child: Text(
                    Globals.currentUser.earnings == null
                        ? ''
                        : Globals.currentUser.earnings.toStringAsFixed(2),
                    style: TextStyle(color: Color(0xff758488))),
              ),
            ),
          ],
        ))
      ],
    );
  }

  void showBuyPage() async {
    bool needRefresh = await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => BuyPage()));

    if (needRefresh != null && needRefresh == true) {
      //User paid. We need to fetch entries...
      print("We need to fetch entries");
      setState(() {});
    }
  }

  void showlandscapeBuyPage() async {
    bool needRefresh = await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => game_BuyPage()));

    if (needRefresh != null && needRefresh == true) {
      //User paid. We need to fetch entries...
      print("We need to fetch entries");
      setState(() {});
    }
  }

  Widget _portraitWidget() {
    return Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  _entryWidget(),
                  SizedBox(height: 20),
                  _winningWidget(),
                  SizedBox(height: 20),
                  ColorizeAnimatedTextKit(
                    totalRepeatCount: double.infinity,
                    pause: Duration(milliseconds: 100),
                    text: ["Instant Revealer"],
                    textStyle: TextStyle(fontSize: 30),
                    colors: [
                      Colors.white,
                      Color(0xff56D9CD),
                      Color(0xffF2385A),
                      Color(0xffF5A503),
                    ],
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 160,
                    child: SubmitShadow(
                      title: 'Reveal!',
                      callback: () {
                        _fireworkState.currentState.refreshAnimation();
                        port_showRevealDialog();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  _gameWidget()
                ],
              ))),
    );
  }

  Widget _landscapeWidget() {
    return Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: _landscape_entryWidget()),
                      SizedBox(width: 20),
                      Flexible(child: _winningWidget()),
                    ],
                  ),
                  SizedBox(height: 20),
                  ColorizeAnimatedTextKit(
                    totalRepeatCount: double.infinity,
                    pause: Duration(milliseconds: 100),
                    text: ["Instant Revealer"],
                    textStyle: TextStyle(fontSize: 30),
                    colors: [
                      Colors.white,
                      Color(0xff56D9CD),
                      Color(0xffF2385A),
                      Color(0xffF5A503),
                    ],
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 160,
                    child: SubmitShadow(
                      title: 'Reveal!',
                      callback: () {
                        _fireworkState.currentState.refreshAnimation();
                        showRevealDialog_landscape();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  _gameWidget(),
                ],
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Welcome"),
            actions: [Image.asset('assets/logo_light.png')]),
        drawer: AppDrawer(
          index: 0,
          callback: showBuyPage,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 0),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover)),
          child: Stack(
            children: [
              _fireworkField,
              Container(
                width: MediaQuery.of(context).size.width,
                child: OrientationBuilder(
                  builder: (BuildContext context, Orientation orientation) {
                    if (MediaQuery.of(context).orientation ==
                        Orientation.portrait) {
                      return _portraitWidget();
                    } else {
                      return _landscapeWidget();
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
