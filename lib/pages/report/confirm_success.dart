
import 'package:covidcapstone/Widgets/Buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfirmSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.red.withOpacity(0.8),
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(30),
                    child: Text("Your Reported that you\ntested positive for\nCOVID-19", style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),)),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Image.asset("assets/hero_woman.png"),
                      width: MediaQuery.of(context).size.width*0.6,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                    Text(
                      "Thank you for helping your community stay safe, anonymously.",
                      style: kMainTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 28.0, 12.0, 0.0),
                        child: FilledButtonAdaptive(
                          text: "SHARE THE APP",
                          tapEvent: (){
                            Navigator.of(context).pushNamedAndRemoveUntil("/homePage", (_) => false);
                          },
                          color: buttonColor,
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    Text(
                      "Your identity will always remain anonymous.",
                      style: kMainTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              )
            ]
          ),
        ),
      ),
    );
  }

}