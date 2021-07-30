import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  EntryField({Key key, this.title, this.teController, this.isPassword})
      : super(key: key);

  final String title;
  final TextEditingController teController;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color(0x33ffffff),
      ),
      child: TextField(
        controller: teController,
        obscureText: isPassword ?? false,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25),
            hintText: this.title,
            hintStyle: TextStyle(color: Colors.white)),
      ),
    );
  }
}
