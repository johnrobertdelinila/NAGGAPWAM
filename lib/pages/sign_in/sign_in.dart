import 'package:covidcapstone/pages/home_page.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'teddy_controller.dart';
import 'tracking_text_input.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TeddyController _teddyController;
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isObscured = true;

  @override
  void initState() {
    _teddyController = TeddyController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(mainColor);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    }

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              mainColor,
              appColor
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  //Todo: Add On Pop Methods Here
                  onPressed: () {
                    print('Add On Pop Methods Here');
                  },
                ),
              ),
              Container(
                height: height * 0.25,
                child: FlareActor(
                  "assets/Teddy.flr",
                  shouldClip: false,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.contain,
                  controller: _teddyController,
                ),
              ),
              Container(
                height: height * 0.45,
                constraints: BoxConstraints(maxWidth: 500),
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(child: Text("Login", style: kSubtitleStyle,)),
                      TrackingTextInput(
                        onTextChanged: (String email) {
                          _email = email;
                        },
                        label: "Email",
                        onCaretMoved: (Offset caret) {
                          _teddyController.lookAt(caret);
                        },
                        icon: Icons.email,
                        enable: !_isLoading,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TrackingTextInput(
                              label: "Password",
                              isObscured: _isObscured,
                              onCaretMoved: (Offset caret) {
                                _teddyController.coverEyes(caret != null);
                                _teddyController.lookAt(null);
                              },
                              onTextChanged: (String password) {
                                _password = password;
                              },
                              icon: Icons.lock,
                              enable: !_isLoading,
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(
                          //       _isObscured
                          //           ? Icons.visibility
                          //           : Icons.visibility_off,
                          //       color: Colors.black45),
                          //   onPressed: () {
                          //     setState(() {
                          //       _isObscured = !_isObscured;
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      FilledButtonAdaptive(
                        text: "Sign In",
                        tapEvent: onPressed,
                        isLoading: _isLoading,
                        color: mainColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressed() async {
    if (_email.isEmpty || _password.isEmpty) {
      showSnackBar('Please Enter Valid Information', _scaffoldKey);
      _teddyController.play('fail');
    } else {
      if (isEmailValid(_email)) {
        setState(() => _isLoading = true);
        bool signInSuccess = await _teddyController.checkEmailPassword(
          email: _email,
          password: _password,
        );
        if (signInSuccess)
          _signInSuccess();
        else
          _signInFailed();
      } else {
        _teddyController.play('fail');
        showSnackBar('Please Enter Valid Email Address', _scaffoldKey);
      }
    }
  }

  // Todo: implement after sign in success
  ///  Sign in successful
  void _signInSuccess() async {
    // Navigator.pushNamedAndRemoveUntil(context, "/qrScan", (route) => false);
    Navigator.pushNamed(context, "/qrScan");
  }

  /// Sign in Fails
  void _signInFailed() {
    showSnackBar('Your email or password is incorrect', _scaffoldKey);
    setState(() => _isLoading = false);
  }
}
