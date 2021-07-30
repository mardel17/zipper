import 'package:flutter/material.dart';
import 'package:zipper/view/account_page.dart';
import 'package:zipper/view/home_page.dart';
import 'package:zipper/view/rule_page.dart';
import 'package:zipper/util/const.dart' as Const;
import 'package:shared_preferences/shared_preferences.dart';

typedef void VoidCallback();
class AppDrawer extends StatelessWidget {
  AppDrawer({Key key, @required this.index, this.callback}) : super(key: key);

  final int index;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // DrawerHeader(child: Container()),
          // Container(
          //   height: 58,
          //   color: Const.PRIMARY_DARK,
          // ),
          ListTile(
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pop();
              if (index != 0) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              }
            },
          ),
          ListTile(
            title: Text("Account"),
            onTap: () {
              Navigator.of(context).pop();
              if (index != 1) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AccountPage()));
              }
            },
          ),
          (index == 0)
              ? ListTile(
                  title: Text("Buy Products"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).pop();
                    callback();
                  })
              : Container(),
          ListTile(
              title: Text("Promotion Rules"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => RulePage()));
              }),
          ListTile(
              title: Text("Logout"),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool(Const.Remember.rule, false);
                prefs.setBool(Const.Remember.login,false);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(Const.ROUTE.LOGIN);
              }),
        ],
      ),
    );
  }
}
