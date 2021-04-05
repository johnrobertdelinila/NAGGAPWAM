

import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/inputs/text_field_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/buttons/text_button_adaptive.dart';
import '../widgets/buttons/filled_button_adaptive.dart';

class PhoneNumberPage extends StatefulWidget {
  _PhoneNumberPageView createState() => _PhoneNumberPageView();
}

class _PhoneNumberPageView extends State<PhoneNumberPage> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 50,
                  right: 20,
                  left: 20,
                  bottom: 10),
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,

              child: Container(
                child: Image.asset("assets/patient.png"),
                width: MediaQuery.of(context).size.width*0.4,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add your phone number?",
                    style: kSubtitleStyle,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      child: Text(
                        "If you've been exposed to someone who has shared they have COVID-19, we will contact you and give you further instructions.",
                        style: kMainTextStyle,
                        textAlign: TextAlign.center,
                      )),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                        top: 30),
                    child: TextFieldAdaptive(
                      placeHolder: "Phone number",
                      prefix: Text("+63"),
                      maxLength: 10, textInputType:
                      TextInputType.number,
                      preController: _controller,
                    ),
                  ),

                  SizedBox(
                    height: (isIos? 15 : 5),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: 30),
                      Icon((isIos ? CupertinoIcons.info_circle_fill : Icons.info), color: Colors.black, size: 20.0),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'We will send ',
                                  style: TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.w400)),
                              TextSpan(
                                  text: 'One Time Password',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text: ' to this mobile number',
                                  style: TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.w400)),
                            ])),
                      ),
                      SizedBox(width: 30),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02,
                        right: MediaQuery.of(context).size.width * 0.02,
                        top: 15),
                    child: FilledButtonAdaptive(
                      text: "Send OTP",
                      tapEvent: (){
                        if(_controller.text.trim().length == 10) {
                          Navigator.of(context).pushNamed("/verify", arguments: _controller.text);
                        }else {
                          showSnackBar("Enter a valid Phone number", _scaffoldKey);
                        }
                      },
                      color: buttonColor,
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  TextButtonAdaptive(
                    text: "Skip",
                    tapEvent: (){
                      Navigator.of(context).pushNamed("/thankYou");
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
