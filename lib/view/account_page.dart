import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zipper/util/const.dart' as Const;
import 'package:zipper/util/globals.dart' as Globals;
import 'package:zipper/view/home_page.dart';
import 'package:zipper/widget/app_drawer.dart';
import 'package:zipper/widget/entry_column.dart';
import 'package:zipper/widget/submit_round.dart';
import 'package:zipper/model/user.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Country _selectedCountry;
  TextEditingController teName = TextEditingController();
  TextEditingController teSurname = TextEditingController();

  TextEditingController teCurrency = TextEditingController();
  TextEditingController tePhone = TextEditingController();
  TextEditingController teMobile = TextEditingController();
  TextEditingController teAddress = TextEditingController();
  TextEditingController teCity = TextEditingController();
  TextEditingController teZip = TextEditingController();

  String _selectedLanguage = Globals.currentUser.lang;

  List<String> _languageList = ['English', 'Ketchup', 'Relish'];

  @override
  void initState() {
    super.initState();

    teName.text = Globals.currentUser.name;
    teSurname.text = Globals.currentUser.surname;
    teCurrency.text = Globals.currentUser.currency;
    tePhone.text = Globals.currentUser.phone;
    teMobile.text = Globals.currentUser.mobile;
    teAddress.text = Globals.currentUser.address;
    teCity.text = Globals.currentUser.city;
    teZip.text = Globals.currentUser.zip;

    _selectedCountry = Country.ALL.firstWhere((element) {
      return element.isoCode == Globals.currentUser.country;
    }, orElse: () => Country.US);
  }

  File _imageFile;
  // dynamic _pickImageError;
  // final ImagePicker _picker = ImagePicker();
  void showImagePicker() async {
    try {
      final pickedFile = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 200, maxHeight: 200);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
    }

    retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    }
  }

  Future updateProfile() async {
    String name = teName.text.trim();

    if (name.isEmpty) {
      Const.showAlertDialog(context, "ZipperGames", "Please input your name");
      return;
    }

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Please wait ... ");
    try {
      await progress.show();
      final http.Response response =
          await http.post(Const.BASE_URL + Const.API.UPDATE_PROFILE,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${Globals.token}'
              },
              body: jsonEncode(<String, dynamic>{
                'name': name,
                'surname': teSurname.text.trim(),
                'lang': _selectedLanguage,
                'country': _selectedCountry.isoCode,
                'phone': tePhone.text.trim(),
                'mobile': teMobile.text.trim(),
                'address': teAddress.text.trim(),
                'city': teCity.text.trim(),
                'zip': teZip.text.trim()
              }));

      await progress.hide();
      print(response.body);

      Map<String, dynamic> result = json.decode(response.body);

      if (response.statusCode == 200) {
        if (result['status'] == 'success') {
          Globals.currentUser = User.fromJson(result['user_info']);

          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              Const.KEY.CURRENT_USER, jsonEncode(Globals.currentUser));
          Const.showToast(context, "Updated Successfully");
        } else {
          Const.showAlertDialog(context, 'ZipperGames', result['message']);
        }
      } else {
        Const.showAlertDialog(context, 'ZipperGames', 'Connection Error');
      }
    } catch (e) {
      await progress.hide();
      Const.showAlertDialog(context, 'ZipperGames', e.toString());
    }
  }

  ImageProvider _profileImage() {
    if (_imageFile != null) {
      return FileImage(_imageFile);
    } else if (Globals.currentUser.path.isEmpty) {
      return AssetImage('assets/avatar.png');
    } else {
      return CachedNetworkImageProvider(Globals.currentUser.path);
    }
  }

  Widget _countryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Country',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xff758488)),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey)),
            child: CountryPicker(
                selectedCountry: _selectedCountry,
                nameTextStyle: TextStyle(fontSize: 16),
                onChanged: (Country country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                }),
          )
        ],
      ),
    );
  }

  Widget _languageWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Preferred Language',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xff758488)),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey)),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
              items: _languageList.map((e) {
                return new DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 16),
                    ));
              }).toList(),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
            ),
          )
        ],
      ),
    );
  }

  Widget _portraitWidget() {
    return Column(
      children: [
        InkWell(
          onTap: showImagePicker,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffCCCCCC), width: 3),
              shape: BoxShape.circle,
              image: DecorationImage(fit: BoxFit.fill, image: _profileImage()),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text('CHOOSE PICTURE',
            style: TextStyle(color: Color(0xff455a64), fontSize: 15)),
        SizedBox(height: 10),
        EntryColumn(
          align: MainAxisAlignment.start,
          title: 'Username',
          hint: Globals.currentUser.username,
          editable: false,
          isRequired: true,
        ),
        EntryColumn(
          align: MainAxisAlignment.start,
          title: 'Email',
          hint: Globals.currentUser.email,
          editable: false,
          isRequired: true,
        ),
        EntryColumn(
          align: MainAxisAlignment.start,
          title: 'Name',
          hint: '',
          teController: teName,
          isRequired: true,
        ),
        EntryColumn(
          align: MainAxisAlignment.start,
          title: 'Surname',
          hint: '',
          teController: teSurname,
        ),
        EntryColumn(
          align: MainAxisAlignment.end,
          title: 'Currency',
          hint: '',
          teController: teCurrency,
        ),
        _languageWidget(),
        _countryWidget(),
        EntryColumn(
          align: MainAxisAlignment.end,
          title: 'Phone',
          hint: '',
          teController: tePhone,
        ),
        EntryColumn(
          align: MainAxisAlignment.end,
          title: 'Mobile Phone',
          hint: '',
          teController: teMobile,
        ),
        EntryColumn(
          align: MainAxisAlignment.end,
          title: 'Address',
          hint: '',
          teController: teAddress,
        ),
        EntryColumn(
          align: MainAxisAlignment.end,
          title: 'City',
          hint: '',
          teController: teCity,
        ),
        EntryColumn(
          align: MainAxisAlignment.end,
          title: 'Zip Code',
          hint: '',
          teController: teZip,
        ),
        Row(
          children: [
            Flexible(
                child: SubmitRound(
              title: "SUBMIT",
              color: Color(0xffED8D00),
              callback: updateProfile,
            )),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: SubmitRound(
              title: "BACK",
              color: Color(0xff1D62F0),
              callback: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              },
            )),
          ],
        ),
      ],
    );
  }

  Widget _landscapeWidget() {
    return Column(
      children: [
        InkWell(
          onTap: showImagePicker,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffCCCCCC), width: 3),
              shape: BoxShape.circle,
              image: DecorationImage(fit: BoxFit.fill, image: _profileImage()),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text('CHOOSE PICTURE',
            style: TextStyle(color: Color(0xff455a64), fontSize: 15)),
        SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.start,
                title: 'Username',
                hint: Globals.currentUser.username,
                editable: false,
                isRequired: true,
              ),
            ),
            SizedBox(width: 20),
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.start,
                title: 'Email',
                hint: Globals.currentUser.email,
                editable: false,
                isRequired: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.start,
                title: 'Name',
                hint: '',
                teController: teName,
                isRequired: true,
              ),
            ),
            SizedBox(width: 20),
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.start,
                title: 'Surname',
                hint: '',
                teController: teSurname,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.end,
                title: 'Currency',
                hint: '',
                teController: teCurrency,
              ),
            ),
            SizedBox(width: 20),
            Flexible(
              child: _languageWidget(),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: _countryWidget(),
            ),
            SizedBox(width: 20),
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.end,
                title: 'Phone',
                hint: '',
                teController: tePhone,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.end,
                title: 'Mobile Phone',
                hint: '',
                teController: teMobile,
              ),
            ),
            SizedBox(width: 20),
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.end,
                title: 'Address',
                hint: '',
                teController: teAddress,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.end,
                title: 'City',
                hint: '',
                teController: teCity,
              ),
            ),
            SizedBox(width: 20),
            Flexible(
              child: EntryColumn(
                align: MainAxisAlignment.end,
                title: 'Zip Code',
                hint: '',
                teController: teZip,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
                child: SubmitRound(
              title: "SUBMIT",
              color: Color(0xffED8D00),
              callback: updateProfile,
            )),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: SubmitRound(
              title: "BACK",
              color: Color(0xff1D62F0),
              callback: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              },
            )),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Account"),
        ),
        drawer: AppDrawer(index: 1),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover)),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Account Management",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff455A64)),
                ),
                SizedBox(height: 10),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 20),
                    child: OrientationBuilder(
                      builder: (BuildContext context, Orientation orientation) {
                        if (MediaQuery.of(context).orientation ==
                            Orientation.portrait) {
                          return _portraitWidget();
                        } else {
                          return _landscapeWidget();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
