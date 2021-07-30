import 'package:flutter/material.dart';

typedef void VoidCallback();

class SubmitButton extends StatelessWidget {
  SubmitButton({Key key, this.title, this.color, this.callback})
      : super(key: key);

  final String title;
  final Color color;
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
            color: color ?? Color(0x881D7EE0)),
        child: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
