import 'package:flutter/material.dart';

typedef void VoidCallback();

class SubmitShadow extends StatelessWidget {
  SubmitShadow({Key key, this.title, this.callback}) : super(key: key);

  final String title;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
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
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Color(0x11F46001), spreadRadius: 4, blurRadius: 4)
          ],
        ),
        child: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
