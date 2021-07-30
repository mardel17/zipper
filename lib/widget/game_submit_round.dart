import 'package:flutter/material.dart';

typedef void VoidCallback();

class GameSubmitRound extends StatelessWidget {
  GameSubmitRound({Key key, this.title, this.color, this.callback})
      : super(key: key);

  final String title;
  final Color color;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: callback,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: screenSize.width / 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)), color: color),
        child: Text(
          title,
          style:
              TextStyle(fontSize: screenSize.width / 45, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
