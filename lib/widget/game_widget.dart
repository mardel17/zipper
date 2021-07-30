import 'package:flutter/material.dart';

typedef void VoidCallback();

class GameWidget extends StatelessWidget {
  GameWidget({Key key, @required this.asset, this.callback}) : super(key: key);

  final String asset;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}
