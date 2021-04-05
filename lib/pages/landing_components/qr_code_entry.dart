import 'package:covidcapstone/Services/constants.dart';
import 'package:covidcapstone/Widgets/Buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/widgets/action_sheet_adaptive.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class Jumbotron extends StatelessWidget {

  final bool isTablet;
  final bool isMobile;

  const Jumbotron({Key key, this.isTablet, this.isMobile}) : super(key: key);

  List<Widget> qrButtons(BuildContext context) {

    return [
      SizedBox(height: (kIsWeb ? 0 : 30),),

      FilledButtonAdaptive(
        text: 'Individual QR Pass',
        color: mainColor,
        tapEvent: () {

          final title = "Individual QR Pass";
          final message = "For individuals who wish to have a NAGGAPWAM QR ID.";
          final msg = Text(message);
          final buttons = [
            {
              "text": "Register",
              "action": (){
                // Navigator.pop(context);
                Navigator.of(context).pushNamed("/individualRegistration");
              }
            },
            {
              "text": "Check Status/Get ID",
              "action": (){
                // Navigator.pop(context);
                Navigator.of(context).pushNamed("/checkStatus");
              }
            },
          ];


          if(isMobile) {
            ActionSheetAdaptive(
              title: title,
              message: message,
              isIncludeCancel: true,
              buttons: buttons,
            ).show(context);
          }else {
            AlertDialogAdaptive(
              title: title,
              content: msg,
              buttons: buttons,
            ).show(context);
          }
        },
      ),

      SizedBox(width: 10, height: 12,),

      FilledButtonAdaptive(
        text: 'QR Scanning Point',
        color: navColor,
        tapEvent: () {

          final title = "QR Scanning Point";
          final message = "For establishments to be registered as QR Scanning Points.";
          final msg = Text(message);
          final buttons = [
            {
              "text": "Register",
              "action": (){
                // Navigator.pop(context);
                Navigator.of(context).pushNamed("/scanningRegistration");
              }
            },
            {
              "text": "Sign In",
              "action": (){
                // Navigator.pop(context);
                Navigator.of(context).pushNamed("/signIn");
              }
            },
          ];

          if(isMobile) {
            ActionSheetAdaptive(
              isIncludeCancel: true,
              title: title,
              message: message,
              buttons: buttons,
            ).show(context);
          }else {
            AlertDialogAdaptive(
              title: title,
              content: msg,
              buttons: buttons,
            ).show(context);
          }
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {

    double largeText = (!isTablet && !isMobile ? 34 : 30);
    double mediumText = (!isTablet && !isMobile ? 29 : 25);
    double subText = (!isTablet && !isMobile ? 20 : 16);

    return Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: (!isTablet && !isMobile ? 40 : 0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:(!isTablet && !isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center),
                    children: <Widget>[
                      (kIsWeb ? Column(
                        crossAxisAlignment:(!isTablet && !isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center),
                        children: [
                          RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: '',
                                        style: TextStyle(
                                            fontSize: largeText,
                                            fontWeight: FontWeight.w800
                                        )
                                    ),
                                    TextSpan(
                                        text: 'NAGGAPWAM',
                                        style: TextStyle(
                                            fontSize: largeText,
                                            fontWeight: FontWeight.w800,
                                            color: mainColor
                                        )
                                    ),
                                  ]
                              )
                          ),

                          Text(
                            'The centralized Covid-19 tracking system of the Province of La Union',
                            style: TextStyle(
                                fontSize: mediumText,
                                fontWeight: FontWeight.w800
                            ),
                          ),

                          Text(
                            'that allows you to instantly and anonymously know if you’ve been exposed to COVID-19, and help more people know their own exposure - empowering us all to stop the spread together.',
                            style: TextStyle(
                                fontSize: mediumText,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                        ],
                      ) : SizedBox(height: 40,)),

                      SizedBox(height: 10),

                      (isTablet || isMobile ? Container(
                        child: Lottie.asset('assets/lotties/landing.json', animate: (kIsWeb && isMobile ? false: true)),
                        width: kIsWeb ? MediaQuery.of(context).size.width *0.8 : null,
                        height: kIsWeb ? MediaQuery.of(context).size.height * 0.5 : null,
                      ) : SizedBox()),

                      Text(
                        'Let us stop the spread of COVID-19.',
                        style: TextStyle(
                            fontSize: subText,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      SizedBox(height: 10),
                      (isMobile ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: qrButtons(context),
                      ) : Row(
                        mainAxisAlignment: (!isTablet && !isMobile ? MainAxisAlignment.start : MainAxisAlignment.center),
                        children: qrButtons(context),
                      ))
                    ],
                  ),
                )
            ),
            (!isTablet && !isMobile ? Expanded(
                child: Lottie.asset('assets/lotties/landing.json', repeat: (kIsWeb ? false: true))
            ) : SizedBox())
          ],
        )
    );
  }

}

