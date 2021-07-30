import 'package:flutter/material.dart';

class EntryColumn extends StatelessWidget {
  EntryColumn(
      {Key key,
      this.align,
      this.title,
      this.hint,
      this.editable,
      this.teController,
      this.isPassword,
      this.isRequired})
      : super(key: key);

  final MainAxisAlignment align;
  final String title;
  final String hint;
  final bool editable;
  final TextEditingController teController;
  final bool isPassword;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: align,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xff758488)),
              ),
              SizedBox(width: 5),
              (isRequired ?? false)
                  ? Text("(required)",
                      style: TextStyle(fontSize: 15, color: Color(0xff9999B3)))
                  : Container(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey)),
            child: TextField(
              enabled: editable ?? true,
              controller: teController,
              obscureText: isPassword ?? false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
            ),
          )
        ],
      ),
    );
  }
}
