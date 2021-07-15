import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/buttons/text_button_adaptive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_spinkit/flutter_spinkit.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class PhoneAuthVerify extends StatefulWidget {
  final Color cardBackgroundColor = backgroundColor;
  final String phoneNumber;

  PhoneAuthVerify({Key key, @required this.phoneNumber}) : super(key: key);
  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState(this.phoneNumber);
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {

  final String phoneNumber;

  double _height, _fixedPadding;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";

  final scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  bool isCodeSent = false, isLoading = false;

  _PhoneAuthVerifyState(this.phoneNumber);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;
    _fixedPadding = _height * 0.025;

    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackBar("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}", scaffoldKey);
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      showSnackBar('Phone number verification failed. Code: ${authException.code}. Message: ${authException.code}', scaffoldKey);
    };

    PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      showSnackBar('Please check sent to phone number +63 $phoneNumber for the verification code.', scaffoldKey);
      _verificationId = verificationId;
      setState(() {
        isCodeSent = true;
      });
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      showSnackBar("verification code: " + verificationId, scaffoldKey);
      _verificationId = verificationId;
    };

    Future<bool> verifyPhoneNumber() async {
      try {
        await _auth.verifyPhoneNumber(
            phoneNumber: "+63" + phoneNumber,
            timeout: const Duration(seconds: 5),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
        return true;
      } catch (e) {
        showSnackBar("Failed to Verify Phone Number: ${e}", scaffoldKey);
        return false;
      }
    }

    void signInWithPhoneNumber() async {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: code,
        );

        final User user = (await _auth.signInWithCredential(credential)).user;

        showSnackBar("Successfully signed in UID: ${user.uid}", scaffoldKey);
        setState(() {
          isLoading = false;
        });
        addStringToSF("phone", "0" + phoneNumber);
        _auth.signOut();
        Navigator.of(context).pushNamedAndRemoveUntil("/thankYou", (route) => false);
      } catch (e) {
        String err = 'Verification code is invalid. Please be sure to enter the correct verification code or resend the verification code sms';
        if(e.toString().contains("invalid-verification-code")) {
          showSnackBar(err, scaffoldKey);
        }else {
          showSnackBar("Failed to sign in: " + e.toString(), scaffoldKey);
        }
        setState(() {
          isLoading = false;
        });

      }
    }

    Widget iosInput(FocusNode focusNode, String key) {
      return CupertinoTextField(
        key: Key(key),
        expands: false,
        autofocus: false,
        focusNode: focusNode,
        onChanged: (String value) {
          if (value.length == 1) {
            code += value;
            switch (code.length) {
              case 1:
                FocusScope.of(context).requestFocus(focusNode2);
                break;
              case 2:
                FocusScope.of(context).requestFocus(focusNode3);
                break;
              case 3:
                FocusScope.of(context).requestFocus(focusNode4);
                break;
              case 4:
                FocusScope.of(context).requestFocus(focusNode5);
                break;
              case 5:
                FocusScope.of(context).requestFocus(focusNode6);
                break;
              default:
                FocusScope.of(context).requestFocus(FocusNode());
                break;
            }
          }
        },
        maxLengthEnforced: false,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black),
      );
    }

    Widget androidInput(FocusNode focusNode, String key) {
      return TextField(
        key: Key(key),
        expands: false,
        autofocus: false,
        focusNode: focusNode,
        onChanged: (String value) {
          if (value.length == 1) {
            code += value;
            switch (code.length) {
              case 1:
                FocusScope.of(context).requestFocus(focusNode2);
                break;
              case 2:
                FocusScope.of(context).requestFocus(focusNode3);
                break;
              case 3:
                FocusScope.of(context).requestFocus(focusNode4);
                break;
              case 4:
                FocusScope.of(context).requestFocus(focusNode5);
                break;
              case 5:
                FocusScope.of(context).requestFocus(focusNode6);
                break;
              default:
                FocusScope.of(context).requestFocus(FocusNode());
                break;
            }
          }
        },
        maxLengthEnforced: false,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
      );
    }

    Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
      height: 40.0,
      width: 35.0,
      child: (isIos ? iosInput(focusNode, key) : androidInput(focusNode, key)),
    );

    void signIn() {
      if (code.length != 6) {
        showSnackBar("Invalid OTP", scaffoldKey);
        return;
      }
      setState(() {
        isLoading = true;
      });
      signInWithPhoneNumber();
    }

    Widget _getColumnBody() => Column(
      children: <Widget>[
        //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
        Padding(
          padding: EdgeInsets.all(_fixedPadding),
          child: Container(
            child: Image.asset("assets/images/logo.png"),
            width: MediaQuery.of(context).size.width*0.4,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
        ),

        // AppName:
        Text(appName.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w700)),

        SizedBox(height: 20.0),

        //  Info text
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: <Widget>[
              SizedBox(width: 16.0),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Please enter the ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: 'One Time Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                        text: ' sent to your mobile',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.0),
            ],
          ),
        ),

        SizedBox(height: 16.0),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getPinField(key: "1", focusNode: focusNode1),
            SizedBox(width: 5.0),
            getPinField(key: "2", focusNode: focusNode2),
            SizedBox(width: 5.0),
            getPinField(key: "3", focusNode: focusNode3),
            SizedBox(width: 5.0),
            getPinField(key: "4", focusNode: focusNode4),
            SizedBox(width: 5.0),
            getPinField(key: "5", focusNode: focusNode5),
            SizedBox(width: 5.0),
            getPinField(key: "6", focusNode: focusNode6),
            SizedBox(width: 5.0),
          ],
        ),

        SizedBox(height: 32.0),

        (!isCodeSent || isLoading ? SpinKitThreeBounce(
          color: Colors.white,
          size: 25.0,
        ) : TextButtonAdaptive(
          color: mainColor,
          text: "VERIFY",
          tapEvent: signIn,
        ))



      ],
    );

    if(!isCodeSent) {
      verifyPhoneNumber();
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: appColor,
      body: Center(
        child: SingleChildScrollView(
          child: _getColumnBody(),
        ),
      ),
    );



  }
}
