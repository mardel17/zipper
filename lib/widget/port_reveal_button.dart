import 'package:flutter/material.dart';

typedef void VoidCallback();

class port_RevealButton extends StatelessWidget {
  port_RevealButton({Key key, this.title, this.callback}) : super(key: key);

  final String title;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: callback,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: screenSize.width/25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffF46001),
                Color(0xffE14802),
              ],
            )),
        child: Text(title, style: TextStyle(fontSize:screenSize.width/30, color: Colors.white)),
      ),
    );
  }
}
