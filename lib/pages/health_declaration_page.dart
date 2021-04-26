
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/models/citizen.dart';
import 'package:covidcapstone/models/health_declaration.dart';
import 'package:covidcapstone/models/naggapwam_static_id.dart';
import 'package:covidcapstone/models/scanned.dart';
import 'package:covidcapstone/pages/qr_registration_page.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:covidcapstone/widgets/buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/widgets/buttons/text_button_adaptive.dart';
import 'package:covidcapstone/widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/checkbox_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/switch_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/text_field_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:jiffy/jiffy.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class HealthDeclarationPage extends StatefulWidget {

  final HealthDeclaration hdf;
  final formKey;
  final Citizen citizen;

  const HealthDeclarationPage({Key key, @required this.hdf, @required this.formKey, @required this.citizen}) : super(key: key);

  @override
  HealthDeclarationPageState createState() => HealthDeclarationPageState(this.formKey, this.hdf, this.citizen);

}

class HealthDeclarationPageState extends State<HealthDeclarationPage> with TickerProviderStateMixin {

  AnimationController controller;

  HealthDeclaration _hdf;
  final _formKey;
  Citizen _citizen;
  String id_number;
  HealthDeclarationPageState(this._formKey, this._hdf, this._citizen);

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);

    if(_citizen == null && NaggapwamStaticId.id_number == null) {
      getStringValuesSF("id_number")
          .then((id_number) {
        if(id_number != null) {
          FirebaseFirestore.instance.collection("hdf").doc(id_number).get()
              .then((doc) {
            setState(() {
              _hdf.fromSnapshot(doc);
              _hdf.haveRead = true;
            });
          });
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> first() {
    return [
      SwitchAdaptive(
        title: "Sore Throat",
        isOn: _hdf.isHaveSoreThroat,
        onChanged: (value) => setState(() {
          _hdf.isHaveSoreThroat = !_hdf.isHaveSoreThroat;
          print("Changed");
        }),
        onTap: () => setState(() {
          _hdf.isHaveSoreThroat = !_hdf.isHaveSoreThroat;
          print("Tap");
        }),
      ),
      SwitchAdaptive(
        title: "Body Pain",
        isOn: _hdf.isHaveBodyPain,
        onChanged: (value) => setState(()  => _hdf.isHaveBodyPain = !_hdf.isHaveBodyPain),
        onTap: () => setState(() => _hdf.isHaveBodyPain = !_hdf.isHaveBodyPain),
      ),
    ];
  }

  List<Widget> second() {
    return [
      SwitchAdaptive(
        title: "Headache",
        isOn: _hdf.isHaveHeadache,
        onChanged: (value) => setState(()  => _hdf.isHaveHeadache = !_hdf.isHaveHeadache),
        onTap: () => setState(() => _hdf.isHaveHeadache = !_hdf.isHaveHeadache),
      ),
      SwitchAdaptive(
        title: "Fever",
        isOn: _hdf.isHaveFever,
        onChanged: (value) => setState(()  => _hdf.isHaveFever = !_hdf.isHaveFever),
        onTap: () => setState(() => _hdf.isHaveFever = !_hdf.isHaveFever),
      ),
    ];
  }

  List<Widget> third() {
    return [
      SwitchAdaptive(
        title: "Worked or stayed together in the same close environment of a confirmed COVID-19 case:",
        isOn: _hdf.isHaveStayed,
        onChanged: (value) => setState(()  => _hdf.isHaveStayed = !_hdf.isHaveStayed),
        onTap: () => setState(() => _hdf.isHaveStayed = !_hdf.isHaveStayed),
      ),
      SwitchAdaptive(
        title: "Had any contact with anyone with fever, cough, colds and sore throat in the past 2 weeks:",
        isOn: _hdf.isHaveContact,
        onChanged: (value) => setState(()  => _hdf.isHaveContact = !_hdf.isHaveContact),
        onTap: () => setState(() => _hdf.isHaveContact = !_hdf.isHaveContact),
      ),
    ];
  }

  List<Widget> fourth() {
    return [
      SwitchAdaptive(
        title: "Travelled outside of the Philippines in the last 14 days:",
        isOn: _hdf.isTravelledOutside,
        onChanged: (value) => setState(()  => _hdf.isTravelledOutside = !_hdf.isTravelledOutside),
        onTap: () => setState(() => _hdf.isTravelledOutside = !_hdf.isTravelledOutside),
      ),
      SwitchAdaptive(
        title: "Travelled to any area in NCR aside from home:",
        isOn: _hdf.isTravelledNCR,
        onChanged: (value) => setState(()  => _hdf.isTravelledNCR = !_hdf.isTravelledNCR),
        onTap: () => setState(() => _hdf.isTravelledNCR = !_hdf.isTravelledNCR),
      ),
    ];
  }

  List<Widget> fifth() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: TextFieldAdaptive(
            placeHolder: "Travelled area in NCR",
            textInputType: TextInputType.text,
            validator: (value) => null,
            selectedValue: _hdf.travelledArea,
            onSaved: (val) => setState(() => _hdf.travelledArea = val)
        ),
      ),
    ];
  }

  void insertScannedHdf(String status) async {
    Scanned scanned = Scanned();
    scanned.id_number = NaggapwamStaticId.id_number;
    scanned.status = status;
    scanned.hdf = _hdf.toJson();
    scanned.scanning_point_id = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection("scanned").add(scanned.toJson()).catchError((onError) => print(onError));

    NaggapwamStaticId.id_number = null;
    NaggapwamStaticId.citizenName = null;
    Navigator.of(context).pushNamedAndRemoveUntil("/scanAgain", (route) => false);
  }

  Widget form(BoxConstraints constraints) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: (NaggapwamStaticId.citizenName != null ? Text(NaggapwamStaticId.citizenName, style: kMainTextStyle,) : SizedBox()),
          ),
          Text("Health Declaration Form", style: kSubtitleStyle,),
          SizedBox(height: 15,),
          layout(constraints, first()),
          layout(constraints, second()),
          layout(constraints, third()),
          layout(constraints, fourth()),
          layout(constraints, fifth()),
          SizedBox(height: 25,),
          (_citizen == null ? SizedBox() : Center(
            child: CheckboxAdaptive(
              title: "I have read and agree to the Terms, Conditions and Privacy Policy",
              isOn: _hdf.haveRead,
              onChanged: (value) => setState(()  => _hdf.haveRead = !_hdf.haveRead),
              onTap: () => setState(() => _hdf.haveRead = !_hdf.haveRead),
            ),
          )),
          NaggapwamStaticId.id_number == null ? Center(
            child: TextButtonAdaptive(
                text: "Terms, Conditions And Privacy Policy",
                tapEvent: () => showTermsAndCondition(context)
            ),
          ) : SizedBox(),
          (_citizen != null ? SizedBox() : Center(child: Text("Updated " + (_hdf.updatedOn != null ? Jiffy(_hdf.updatedOn.toDate()).fromNow() : "--")),)),
          (NaggapwamStaticId.id_number == null ? SizedBox() : Center(child: Text("Temperature: " + (_hdf.temperature != null ? _hdf.temperature : "--")))),
          (!kIsWeb ?
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: Center(
              child: NaggapwamStaticId.id_number != null ? Column(
                children: [
                  ButtonTheme(
                    minWidth: double.maxFinite,
                    height: 58.0,
                    child: OutlineButton(
                      onPressed: () => insertScannedHdf("accepted"),
                      borderSide: new BorderSide(
                        width: 2.0,
                        color: Colors.green
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                      child: Text(
                        "Accept".toUpperCase(),
                        style: Theme.of(context).textTheme.button.apply(
                          color: Color(0xFF686868),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  ButtonTheme(
                    minWidth: double.maxFinite,
                    height: 58.0,
                    child: OutlineButton(
                      onPressed: () => insertScannedHdf("rejected"),
                      borderSide: new BorderSide(
                        width: 2.0,
                        color: Colors.red
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                      child: Text(
                        "Reject".toUpperCase(),
                        style: Theme.of(context).textTheme.button.apply(
                          color: Color(0xFF686868),
                        ),
                      ),
                    ),
                  )
                ],
              ) : FilledButtonAdaptive(color: buttonColor, text: "Submit", tapEvent: () {
                if (_formKey.currentState.validate()) {
                  if(!_hdf.haveRead) {
                    AlertDialogAdaptive(
                      title: "Terms and Condition",
                      content: Text("Make sure that you've agree to the Terms, Conditions and Privacy Policy."),
                      buttons: [
                        {
                          "text": "Okay",
                          "action": () => Navigator.pop(context)
                        },
                      ],
                    ).show(context);
                  }else {
                    if(_citizen != null) {
                      AlertDialogAdaptive(
                        title: "Please wait",
                        barrierDismissible: false,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Creating you a NAGGAPWAM QR Pass ID."),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: (isIos ? CupertinoActivityIndicator(
                                animating: true,
                                radius: 20,
                              ) : CircularProgressIndicator()),
                            )
                          ],
                        ),
                        buttons: [],
                      ).show(context);
                      QrRegistrationPage().insert(_citizen, _hdf, context);
                    }else {
                      QrRegistrationPage().update(_hdf, id_number);
                      AlertDialogAdaptive(
                        title: "Health Declaration",
                        content: Text("Thank you for updating your Health Declaration Form!"),
                        buttons: [
                          {
                            "text": "Done",
                            "action": () {
                              Navigator.pop(context);
                              Navigator.of(context).pop();
                            }
                          },
                        ],
                      ).show(context);
                    }
                  }
                }
              }),
            ),
          ) : SizedBox())
        ],
      ),
    );
  }

  Widget layout(BoxConstraints constraints, List<Widget> widgets) {
    if(constraints.maxWidth <= 600) {
      // Mobile layout
      return Column(
        children: List<Widget>.generate(widgets.length, (index) {
          return Padding(padding: EdgeInsets.only(bottom: 5), child: widgets[index],);
        }),
      );
    }else {
      return Row(
        children: List<Widget>.generate(widgets.length, (int index) {
          return Expanded(
            flex: 1,
            child: Padding(padding: EdgeInsets.only(left: 8, right: 8, bottom: 5), child: widgets[index]),
          );
        }),
      );
    }
  }

  Widget layoutBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: constraints.maxWidth >= 600 ? 30 : 20 ),
          child: constraints.maxWidth >= 600 ? Card(
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: form(constraints),
            ),
          ) : form(constraints),
        );
      },
    );
  }

  FutureBuilder<DocumentSnapshot> fetchHdf(String id_number) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("hdf").doc(id_number).get(),
      builder: (context, docSnapshot) {
        if(docSnapshot.hasData) {
          if(docSnapshot.hasError) {
            return Center(
              child: Text(docSnapshot.error.toString()),
            );
          }
          if(NaggapwamStaticId.id_number != null) {
            _hdf.fromSnapshot(docSnapshot.data);
            _hdf.haveRead = true;
          }
          return layoutBuilder();
        }else {
          return Center(
            child: (isIos ? CupertinoActivityIndicator(
              animating: true,
              radius: 20,
            ) : CircularProgressIndicator()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(kIsWeb) {
      return layoutBuilder();
    }else {
      return ScaffoldAdaptive(
        isIncludeBottomBarAndroid: false,
        child: CustomScrollviewAdaptive(
          icon: SizedBox(),
          title: NaggapwamStaticId.id_number != null ? "QR Pass ID" : _citizen != null ? "QR Pass Registration" : "Update HDF",
          widgets: [
            (_citizen != null ? layoutBuilder() :
              (NaggapwamStaticId.id_number != null ? fetchHdf(NaggapwamStaticId.id_number) : FutureBuilder(
                future: getStringValuesSF("id_number"),
                builder: (context, snap) {
                  if(snap.hasData && snap.data != null) {
                    id_number = snap.data.toString();
                    return fetchHdf(snap.data.toString());
                  }else {
                    return Center(
                      child: Text("Something went wrong"),
                    );
                  }
                },
              ))
            )
          ],
        ),
      );
    }
  }


}