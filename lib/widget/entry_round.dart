import 'package:flutter/material.dart';

class EntryRound extends StatelessWidget {
  EntryRound(
      {Key key,
      this.title,
      this.teController,
      this.isPassword,
      this.editable,
      this.inputType})
      : super(key: key);

  final String title;
  final TextEditingController teController;
  final bool isPassword;
  final bool editable;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xffffffff),
      ),
      child: TextField(
        enabled: editable ?? true,
        controller: teController,
        obscureText: isPassword ?? false,
        keyboardType: inputType ?? TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25),
            hintText: this.title),
      ),
    );
  }
}
