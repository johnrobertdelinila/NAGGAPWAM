
import 'package:covidcapstone/Widgets/Buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThankYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: mainColor.withOpacity(0.2),
                child: Lottie.asset('assets/lotties/thank_you.json'),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "You've joined our team of 2 million",
                      style: kMainTitleStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Thanks for downloading and using Naggapwam app to " + tagline.toLowerCase() + ".",
                      style: kMainTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      subTagline + ".",
                      style: kMainTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 28.0, 12.0, 0.0),
                        child: FilledButtonAdaptive(
                          text: "Finish",
                          tapEvent: (){
                            Navigator.of(context).pushNamedAndRemoveUntil("/homePage", (_) => false);
                          },
                          color: buttonColor,
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
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