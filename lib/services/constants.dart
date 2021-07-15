

import 'dart:ui';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
bool get isAndroid => foundation.defaultTargetPlatform == foundation.TargetPlatform.android;
final bool isDeveloping = false;


final Color backgroundColor = Color(0xFFFAFAFA);
final Color mainColor = Color(0xFF475df3);
final Color navColor = Color(0xFF2C3054);
final Color selectedItemColor = /*Color.fromRGBO(254, 198, 208, 1)*/ Colors.white;
final Color buttonColor = Color(0xFF475df3);
const kTextColor = Color(0XFF282828);

final double borderRadius = kIsWeb ? 20.0 : 14.0;
final double elevation = 0;

final String terms = "https://naggapwam.flycricket.io/terms.html";
final String privacy = "https://naggapwam.flycricket.io/privacy.html";

final MaterialColor appColor = MaterialColor(
  Color.fromRGBO(44, 48, 84, 1.0).value,
  <int, Color>{
    50: Color.fromRGBO(44, 48, 84, .1),
    100: Color.fromRGBO(44, 48, 84, .2),
    200: Color.fromRGBO(44, 48, 84, .3),
    300: Color.fromRGBO(44, 48, 84, .4),
    400: Color.fromRGBO(44, 48, 84, .5),
    500: Color.fromRGBO(44, 48, 84, .6),
    600: Color.fromRGBO(44, 48, 84, .7),
    700: Color.fromRGBO(44, 48, 84, .8),
    800: Color.fromRGBO(44, 48, 84, .9),
    900: Color.fromRGBO(44, 48, 84, 1),
  },
);

final Color darkColor = Color.fromRGBO(227, 203, 228, 1);

final kMainTitleStyle = TextStyle(
  // color: Color.fromRGBO(227, 203, 228, 1),
  color: kTextColor,
  fontWeight: FontWeight.w700,
  fontSize: 29.0,
);

final kSubtitleStyle = TextStyle(
  // color: Color.fromRGBO(227, 203, 228, 1),
  color: navColor,
  fontWeight: FontWeight.w500,
  fontSize: 22.0,
);

final kMainTextStyle = TextStyle(
  // color: Color.fromRGBO(227, 203, 228, 1),
  color: kTextColor,
  fontSize: 19.0,
);

final String appName = "Naggapwam";
final String tagline = "Protect yourself, your family, and your community";
final String subTagline = "Together we can stop the spread of COVID-19";

final List<String> navigations = ["Dashboard", "Record Visit", "More"];

final List<String> genders = [
  "Female",
  "Male",
];

final List<String> barangays = [
  "BARANGAY I", "BARANGAY II", "BARANGAY III", "BARANGAY IV", "ILOCANOS NORTE"
];

final List<String> relationships = [
  "Father", "Mother", "Brother", "Sister", "Grandmother", "Grandfather", "Spouse", "Relative", "Friend", "Colleague", "Employer", "Neighbor", "Others"
];

final List<String> categories = [
  "Government", "Private", "Commercial", "School", "Health", "Transportation", "Worship"
];

//Helper Methods
/// Method to validate email id returns true if email is valid
bool isEmailValid(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (regex.hasMatch(email))
    return true;
  else
    return false;
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

void showSnackBar(String title, GlobalKey<ScaffoldState> _scaffoldKey) => _scaffoldKey.currentState.showSnackBar(
  SnackBar(
    content: Text(title, textAlign: (isIos ? TextAlign.center : TextAlign.start)),
  ),
);

onShareWithEmptyOrigin() async {
  await Share.share(tagline + ". " + subTagline + ".\n\nApp Link: naggapwam-covid-tracing.web.app");
}

addStringToSF(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<dynamic> getStringValuesSF(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringValue = prefs.getString(key);
  return stringValue;
}

String capitalize(String str) {
  return "${str[0].toUpperCase()}${str.substring(1)}";
}

void showTermsAndCondition(BuildContext context) {
  if(kIsWeb) {
    canLaunch(terms);
  }else {
    AlertDialogAdaptive(
      title: "Terms & Condition",
      barrierDismissible: true,
      content: Container(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse(terms)
          ),
        ),
      ),
      buttons: [],
    ).show(context);
  }
}

const disclaimer_registration = "Please register ONLY ONCE and wait to get verified. Information must be truthful and reviewed carefully before submission. "
    "This app supports contact tracing while maintaining privacy. Your identity will never be revealed to other app users.";

const acquisition = "Once the Developer gives the work product to the Client, the Developer does not have rights to it, "
    "except those that the Client explicitly gives the Developer here. The Client gives the Developer permission to use the "
    "work product as part of the Developers portfolio and websites, in galleries, and in other media, "
    "so long as is to showcase the Developers work and not for any other purpose. The Developer is not allowed to sell or otherwise use the work product to make money or for any other commercial"
    "use. The Client is not allowed to take back this license, even after the Contract ends.";