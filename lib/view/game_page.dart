import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zipper/view/game_buy_page.dart';
import 'package:zipper/view/buy_page.dart';
import 'package:zipper/util/globals.dart' as Globals;
import 'package:zipper/util/const.dart' as Const;
import 'package:zipper/widget/reveal_button.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, @required this.url, this.screenmode}) : super(key: key);
  final String url;
  final bool screenmode;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final String channelName = 'bet-channel';
  final String eventName = 'bet-event';
  var entriesReveal;
  var awardReveal;

  Channel channel;

  @override
  void initState() {
    super.initState();
    initPusher();
   if(widget.screenmode==true){  SystemChrome.setPreferredOrientations(
       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);}else{
     SystemChrome.setPreferredOrientations(
         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
   }


  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    closePusher();
    super.dispose();
  }

  void closePusher() async {
    if (channel != null) channel.unbind(eventName);
    await Pusher.unsubscribe(channelName);
    await Pusher.disconnect();
  }

  void initPusher() async {
    try {
      PusherOptions options = new PusherOptions(cluster: Const.PUSHER.CLUSTER);
      await Pusher.init(Const.PUSHER.KEY, options);
      await Pusher.connect(onConnectionStateChange: (x) {
        print('pusher >>> ${x.currentState}');
      }, onError: (x) {
        print('pusher >>> Connection Error: ${x.message}');
      });
      channel = await Pusher.subscribe(channelName);
      if (channel != null)
        channel.bind(eventName, (e) {
          print('pusher data >>> ${e.data}');
          Map<String, dynamic> data = json.decode(e.data.toString());
          print('pusher user >>> ${data['user_id']}');
          if (data['user_id'] == Globals.currentUser.id) {
            setState(() {
              var prevEarnings = Globals.currentUser.earnings;
              var prevEntries = Globals.currentUser.entries;
              entriesReveal = prevEntries - data['entries'];
              awardReveal = data['earnings'] - prevEarnings;

              Globals.currentUser.earnings = data['earnings'];
              Globals.currentUser.entries = data['entries'];
            });
          }
        });
    } on PlatformException catch (e) {
      print('pusher >>> ${e.message}');
    }
  }

  Widget _entryWidget() {
    var screenSize = MediaQuery.of(context).size;
    return widget.screenmode==true?Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: screenSize.width*0.02),
          child: Text('ENTRIES',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width / 45,
                  fontWeight: FontWeight.w400)),
        ),
        Container(width: screenSize.width*0.2,child:  Row(
          children: [
            Expanded(
              child: Container(
                height: screenSize.width / 25,
                padding:
                EdgeInsets.symmetric(horizontal: screenSize.width / 80),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Color(0xffAAB8CE),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(screenSize.width / 120),
                        bottomLeft: Radius.circular(screenSize.width / 120))),
                child: Center(
                    child: Text(Globals.currentUser.entries.toString(),
                        style: TextStyle(
                            fontSize: screenSize.width / 55,
                            color: Colors.black87))),
              ),
            ),
            InkWell(
              onTap: showBuyPage,
              child: Container(
                width: screenSize.width / 25,
                height: screenSize.width / 25,
                decoration: BoxDecoration(
                    color: Color(0xff1976D2),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(screenSize.width / 120),
                        bottomRight: Radius.circular(screenSize.width / 120))),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: screenSize.width / 30,
                ),
              ),
            )
          ],
        ) )

      ],
    ):Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: screenSize.width*0.02),
          child: Text('ENTRIES',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width / 40,
                  fontWeight: FontWeight.w400)),
        ),
        Container(width: screenSize.width*0.25,child:  Row(
          children: [
            Expanded(
              child: Container(
                height: screenSize.width / 20,
                padding:
                EdgeInsets.symmetric(horizontal: screenSize.width / 80),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Color(0xffAAB8CE),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(screenSize.width / 120),
                        bottomLeft: Radius.circular(screenSize.width / 120))),
                child: Center(
                    child: Text(Globals.currentUser.entries.toString(),
                        style: TextStyle(
                            fontSize: screenSize.width / 35,
                            color: Colors.black87))),
              ),
            ),
            InkWell(
              onTap: showBuyPage,
              child: Container(
                width: screenSize.width / 20,
                height: screenSize.width / 20,
                decoration: BoxDecoration(
                    color: Color(0xff1976D2),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(screenSize.width / 120),
                        bottomRight: Radius.circular(screenSize.width / 120))),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: screenSize.width / 30,
                ),
              ),
            )
          ],
        ) )

      ],
    );
  }

  void showBuyPage() async {
    bool needRefresh = await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => widget.screenmode==true?game_BuyPage():BuyPage()));

    if (needRefresh != null && needRefresh == true) {
      //User paid. We need to fetch entries...
      print("We need to fetch entries");
      setState(() {});
    }
  }

  Widget _winningWidget() {
    var screenSize = MediaQuery.of(context).size;
    return widget.screenmode==true?Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: screenSize.width*0.02),
          child: Text('WINNINGS',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width / 45,
                  fontWeight: FontWeight.w400)),
        ),
        Container(width: screenSize.width*0.2,child: Row(
          children: [
            Container(
              width: screenSize.width / 25,
              height: screenSize.width / 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenSize.width / 120),
                      bottomLeft: Radius.circular(screenSize.width / 120))),
              child: Icon(
                Icons.attach_money,
                size: screenSize.width / 30,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Container(
                height: screenSize.width / 25,
                padding:
                EdgeInsets.symmetric(horizontal: screenSize.width / 45),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Color(0xffAAB8CE),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(screenSize.width / 120),
                        bottomRight: Radius.circular(screenSize.width / 120))),
                child: Text(Globals.currentUser.earnings.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: screenSize.width / 55,
                        color: Colors.black87)),
              ),
            ),

          ],
        ) )

      ],
    ):Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: screenSize.width*0.02),
          child: Text('WINNINGS',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width / 35,
                  fontWeight: FontWeight.w400)),
        ),
        Container(width: screenSize.width*0.22,child: Row(
          children: [
            Container(
              width: screenSize.width / 20,
              height: screenSize.width / 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenSize.width / 120),
                      bottomLeft: Radius.circular(screenSize.width / 120))),
              child: Icon(
                Icons.attach_money,
                size: screenSize.width / 30,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Container(
                height: screenSize.width / 20,
                padding:
                EdgeInsets.symmetric(horizontal: screenSize.width / 45),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Color(0xffAAB8CE),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(screenSize.width / 120),
                        bottomRight: Radius.circular(screenSize.width / 120))),
                child: Text(Globals.currentUser.earnings.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: screenSize.width / 35,
                        color: Colors.black87)),
              ),
            ),

          ],
        ) )

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    Map<String, String> header = {
      'Authorization': 'Bearer ${Globals.token}',
      "Accept": "application/json"
    };
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       icon: Icon(Icons.arrow_back),
      //       onPressed: () => Navigator.of(context).pop()),
      //   title: Row(
      //     children: [
      //       Flexible(child: _entryWidget()),
      //       SizedBox(width: 20),
      //       Flexible(child: _winningWidget())
      //     ],
      //   ),
      // ),
      body: Column(
        children: [
          widget.screenmode==true?Container(
              decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage('assets/background.jpg'),
                  //   fit: BoxFit.fill,
                  // )
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff060949), Color(0xff1c5093)],
                  )

              ),
            padding: EdgeInsets.only(top:screenSize.height*0.06),
            height: screenSize.height*0.18,
             child:Row(children: [

               InkWell(
                 onTap: () => Navigator.of(context).pop(),
                 child: Container(
                   margin: EdgeInsets.only(left: screenSize.width*0.05),
                   width: screenSize.width / 20,
                   height: screenSize.width / 20,
                   decoration: BoxDecoration(
                       borderRadius:
                       BorderRadius.all(Radius.circular(screenSize.width / 18)),
                       border: Border.all(color: Colors.white.withOpacity(0.6)),
                       color: Colors.black.withOpacity(0.6)),
                   child: Icon(
                     Icons.arrow_back,
                     color: Colors.white,
                     size: screenSize.width / 25,
                   ),
                 ),
               ),
               Container(
                 margin: EdgeInsets.only(left: screenSize.width*0.1),
                 width: MediaQuery.of(context).size.width * 0.35,
                 child:  _entryWidget(),
               ),
               Container(
                   margin: EdgeInsets.only(left: screenSize.width*0.01),
                   width: MediaQuery.of(context).size.width * 0.35,child:_winningWidget())
             ],)
          ):Container(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage('assets/background.jpg'),
                //   fit: BoxFit.fill,
                // )
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff060949), Color(0xff1c5093)],
                  )

              ),
              padding: EdgeInsets.only(top:screenSize.height*0.035,bottom: screenSize.height*0.005),
              height: screenSize.height*0.1,
              child:Row(children: [

                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: EdgeInsets.only(left: screenSize.width*0.05),
                    width: screenSize.width / 15,
                    height: screenSize.width / 15,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(screenSize.width / 18)),
                        border: Border.all(color: Colors.white.withOpacity(0.6)),
                        color: Colors.black.withOpacity(0.6)),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: screenSize.width / 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: screenSize.width*0.05),
                  width: MediaQuery.of(context).size.width * 0.40,
                  child:  _entryWidget(),
                ),
                Container(
                    margin: EdgeInsets.only(left: screenSize.width*0.01),
                    width: MediaQuery.of(context).size.width * 0.40,child:_winningWidget())
              ],)
          ),
          widget.screenmode==true?Container(
            height: screenSize.height*0.82,
           child: Stack(
             children: [
               Container(
                 width: screenSize.width,
                 height: screenSize.height,
                 decoration: BoxDecoration(
                     image: DecorationImage(
                       image: AssetImage('assets/background.jpg'),
                       fit: BoxFit.fill,
                     )),
               ),
               SingleChildScrollView(
                 child: Container(
                   // margin: EdgeInsets.only(
                   //     top: screenSize.height * 0.05, left: screenSize.width * 0.22),
                   height: MediaQuery.of(context).size.height *0.82,
                   width: screenSize.width ,
                   child: WebView(
                     // initialUrl: widget.url,
                       javascriptMode: JavascriptMode.unrestricted,
                       onWebViewCreated: (WebViewController webViewController) {
                         String url =
                             '${widget.url}?entries=${Globals.currentUser.entries}&token=${Globals.token}&VALUE_100_ENTRIES=100';

                         webViewController.loadUrl(url, headers: header);
                       }),
                 ),
               ),

               // Container(
               //   margin: EdgeInsets.only(left:screenSize.width/36,right:screenSize.width/36,bottom:screenSize.width/36,top:screenSize.width/3.5),
               //   width: MediaQuery.of(context).size.width * 0.13,
               //   height: MediaQuery.of(context).size.height,
               //   child: Column(
               //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               //     children: [
               //       RevealButton(title: '${entriesReveal ?? ""}'),
               //       SizedBox(
               //           width: screenSize.width/25, height: screenSize.width/20, child: RevealButton(title: '->')),
               //       RevealButton(title: '${awardReveal ?? ""}\$')
               //     ],
               //   ),
               // ),
             ],
           )
          ):Container(
              height: screenSize.height*0.9,
              child: Stack(
                children: [
                  Container(
                    width: screenSize.width,
                    height: screenSize.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background.jpg'),
                          fit: BoxFit.fill,
                        )),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      // margin: EdgeInsets.only(
                      //     top: screenSize.height * 0.05, left: screenSize.width * 0.22),
                      height: MediaQuery.of(context).size.height *0.9,
                      width: screenSize.width ,
                      child: WebView(
                        // initialUrl: widget.url,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (WebViewController webViewController) {
                            String url =
                                '${widget.url}?entries=${Globals.currentUser.entries}&token=${Globals.token}&VALUE_100_ENTRIES=100';

                            webViewController.loadUrl(url, headers: header);
                          }),
                    ),
                  ),

                  // Container(
                  //   margin: EdgeInsets.only(left:screenSize.width/36,right:screenSize.width/36,bottom:screenSize.width/36,top:screenSize.width/3.5),
                  //   width: MediaQuery.of(context).size.width * 0.13,
                  //   height: MediaQuery.of(context).size.height,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       RevealButton(title: '${entriesReveal ?? ""}'),
                  //       SizedBox(
                  //           width: screenSize.width/25, height: screenSize.width/20, child: RevealButton(title: '->')),
                  //       RevealButton(title: '${awardReveal ?? ""}\$')
                  //     ],
                  //   ),
                  // ),
                ],
              )
          )
        ],
      ),
    );
  }
}
