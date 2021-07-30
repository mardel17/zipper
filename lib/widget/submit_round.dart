import 'package:flutter/material.dart';

typedef void VoidCallback();

class SubmitRound extends StatelessWidget {
  SubmitRound({Key key, this.title, this.color, this.callback, this.fontSize})
      : super(key: key);

  final String title;
  final Color color;
  final VoidCallback callback;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)), color: color),
        child: Text(
          title,
          style: TextStyle(fontSize: fontSize ?? 16, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
