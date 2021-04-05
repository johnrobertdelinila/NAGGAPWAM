import 'dart:io';

import 'package:covidcapstone/Services/constants.dart';
import 'package:covidcapstone/Widgets/Buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/Widgets/icons.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

class GettingStarted extends StatefulWidget {
  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {

  bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

  @override
  String screenName() {
    return "screen_getting_started";
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.85),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Getting Started",
                      style: kMainTitleStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Here is how your information will be used to hep stop the spread of COVID-19.",
                      style: kSubtitleStyle,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ListTile(
                      leading: notif,
                      title: Text("Notifications",
                          style: kMainTextStyle),
                      subtitle: Padding(
                        child: Text(
                            "Naggapwam will send you notifications to hep you assess your risk of becoming infected based on anonymous data.",
                            style: kMainTextStyle),
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                      ),
                    ),
                    Divider(
                      color: Color.fromRGBO(227, 203, 228, 1),
                      height: 0.5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: bluetooth,
                      title: Text(
                        "Bluetooth",
                        style: kMainTextStyle,
                      ),
                      subtitle: Padding(
                        child: Text(
                            "Naggapwam will use your bluetooth anonymously so that the community can asses their risk of becoming infected.",
                            style: kMainTextStyle),
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 28.0, 12.0, 0.0),
                    child: FilledButtonAdaptive(
                      text: "Continue",
                      tapEvent: (){
                        Navigator.of(context).pushNamed("/phoneNumber");
                      },
                      color: buttonColor,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future onPressedBtnGetStarted(BuildContext context) async {
    // await PushNotifications.registerNotification();
    // try {
    //   await LocationUpdates.requestPermissions();
    //   var denied =
    //       await LocationUpdates.arePermissionsDenied();
    //   if (denied) {
    //     onPermissionsDenied(context);
    //   } else {
    //     await onPremissionAvailable(context);
    //     await CTAnalyticsManager.instance.logPermissionsGranted();
    // }
    // } catch (ex) {
    //   onPermissionsDenied(context);
    // }
  }

  void onPermissionsDenied(BuildContext context) {
    // LocationUpdates
    //     .showLocationPermissionsNotAvailableDialog(
    //         context);
  }

  Future onPremissionAvailable(BuildContext context) async {
    //        showLoadingDialog(tapDismiss: false);
    // await ApiRepository.setOnboardingDone(true);
    // hideLoadingDialog();
    navigateCollectInformation(context);
  }

  void navigateCollectInformation(BuildContext context) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => UserInfoCollectorScreen()),
    //     (route) => false);
  }

  Future<bool> showDialogForLocation() {
    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (BuildContext contextDialog) {
            return CupertinoAlertDialog(
              title: Text(
                "let.coronatrace.access",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text("this.helps.us.spread"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("not.now"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                CupertinoDialogAction(
                  child: Text("give.access"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });
    } else {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contextDialog) {
          return AlertDialog(
            title: Text(
              "let.coronatrace.access",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text("this.helps.us.spread"),
            actions: <Widget>[
              FlatButton(
                child: Text("not.now"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("give.access"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
