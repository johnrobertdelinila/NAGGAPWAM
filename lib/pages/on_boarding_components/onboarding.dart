import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:covidcapstone/Widgets/scrollbar_adaptive.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 12.0,
      width: 12.0,
      decoration: BoxDecoration(
        color: isActive ? mainColor : Colors.black12, //Color.fromARGB(50, 255, 255, 255)
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(backgroundColor);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setNavigationBarColor(navColor);

    var platform = Theme.of(context).platform;
    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            // color: Color(0xFF2c3054),
            color: Color(0xFFFAFAFA),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        getFirstPage(),
                        getSecondPage(),
                        getThirdPage(),
                        getFourthPage(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  getBottomButton(platform == TargetPlatform.iOS)
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget getFirstPage() {
    return ScrollbarAdaptive(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.85),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/firstonboarding.png"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  tagline,
                  style: kMainTitleStyle,
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  subTagline,
                  style: kSubtitleStyle,
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  appName + " is a free app that allows you to instantly and anonymously know if you’ve been exposed to COVID-19, and help more people know their own exposure - empowering us all to stop the spread together.",
                  style: kMainTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSecondPage() {
    return ScrollbarAdaptive(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.85),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Lottie.asset('assets/lotties/bluetooth.json'),
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                Text(
                  "Bluetooth Tracing",
                  textAlign: TextAlign.start,
                  style: kSubtitleStyle,
                ),
                SizedBox(height: 15.0),
                Align(
                  child: Text(
                    "Use Bluetooth to anonymously log when you are near other app users.",
                    textAlign: TextAlign.left,
                    style: kMainTextStyle,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getThirdPage() {
    return ScrollbarAdaptive(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.85),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Lottie.asset('assets/lotties/qrscan.json'),
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                Text(
                  "Privileged Entry",
                  style: kSubtitleStyle,
                ),
                SizedBox(height: 15.0),
                Text(
                  "Track your visits by scanning QR codes and checking into locations.",
                  textAlign: TextAlign.left,
                  style: kMainTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getFourthPage() {
    return ScrollbarAdaptive(
      child: SingleChildScrollView(
          child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.85),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                child: Lottie.asset('assets/lotties/status.json'),
                alignment: Alignment.center,
              ),
              Text(
                "Clear & Meaningful Status",
                style: kSubtitleStyle,
              ),
              SizedBox(height: 15.0),
              Text(
                "Anonymous self-reporting is based on clear guidelines with actionable next steps for people that might need help.",
                style: kMainTextStyle,
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget androidBtn(buttonTitle) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 14.0),
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(borderRadius),
      ),
      color: mainColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            buttonTitle,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 20,
          ),
          Visibility(
            child: Icon(Icons.arrow_forward, color: Colors.white),
            visible: _currentPage == 0 || _currentPage == 3,
          )
        ],
      ),
      onPressed: () async {
        if (_currentPage < 3) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/getStarted', (route) => false);
        }
      },
    );
  }

  Widget iosBtn(buttonTitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        color: mainColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              buttonTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 20,
            ),
            Visibility(
              child: Icon((!isIos ? Icons.arrow_forward : CupertinoIcons.forward), color: Colors.white),
              visible: _currentPage == 0 || _currentPage == 3,
            )
          ],
        ),
        onPressed: () async {
          if (_currentPage < 3) {
            _pageController.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil('/getStarted', (route) => false);
          }
        },
      ),
    );
  }

  Widget getBottomButton(isIos) {
    String buttonTitle = "";

    switch (_currentPage) {
      case 0:
        {
          buttonTitle = "See How it Works";
        }
        break;
      case 3:
        {
          buttonTitle = "Get Started";
        }
        break;
      default:
        {
          buttonTitle = "Continue";
        }
    }
    return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 36.0, 12.0, 0.0),
        child: isIos ? iosBtn(buttonTitle) : androidBtn(buttonTitle));
  }

  @override
  String screenName() {
    return "screen_onboarding";
  }
}
