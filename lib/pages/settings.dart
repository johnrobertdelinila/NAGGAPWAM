import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:flutter/cupertino.dart';
/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final TextStyle whiteText = TextStyle(
    color: Colors.white,
  );
  final TextStyle greyTExt = TextStyle(
    color: Colors.grey.shade400,
  );
  @override
  Widget build(BuildContext context) {

    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            // const SizedBox(height: 30.0),
            // const SizedBox(height: 20.0),
            ListTile(
              title: Text(
                "My contact details",
                style: kMainTextStyle,
              ),
              subtitle: FutureBuilder(
                future: getStringValuesSF("phone"),
                initialData: Text("Help us contact you faster if we need to", style: greyTExt,),
                builder: (context, result) {
                  if(result.hasData && result.data != null) {
                    String phone = result.data.toString();
                    return Text(phone.substring(0, 3) + "******" + phone.substring(9, 11), style: greyTExt,);
                  }else {
                    return Text("Help us contact you faster if we need to", style: greyTExt,);
                  }
                },
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "My QR Pass ID",
                style: kMainTextStyle,
              ),
              subtitle: Text(
                "View the current NAPANAM ID",
                style: greyTExt,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () async {
                String id_number = await getStringValuesSF("id_number");
                if(id_number != null) {

                  AlertDialogAdaptive(
                    title: "Please wait",
                    barrierDismissible: false,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Fetching your NAGGAPWAM QR Pass ID."),
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

                  FirebaseFirestore.instance.collection("citizens").doc(id_number).get()
                    .then((docSnapshot) {

                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil("/successPage", (bool) => false, arguments: {
                        "name": capitalize(docSnapshot.get("firstname")) + " " + capitalize(docSnapshot.get("middlename").substring(0, 1)) + ". " + capitalize(docSnapshot.get("lastname")),
                        "address": docSnapshot.get("barangay"),
                        "id_number": id_number,
                        "isCheking": true
                      });
                    });
                }else {
                  AlertDialogAdaptive(
                    title: "Pass ID",
                    barrierDismissible: false,
                    content: Text("No Naggapwam Pass ID found."),
                    buttons: [
                      {
                        "text": "Okay",
                        "action": (){
                          Navigator.pop(context);
                        }
                      },
                    ],
                  ).show(context);
                }
              },
            ),
            FutureBuilder(
              future: getStringValuesSF("id_number"),
              initialData: Text("Help us contact you faster if we need to", style: greyTExt,),
              builder: (context, result) {
                if(result.hasData && result.data != null) {
                  return ListTile(
                    title: Text(
                      "Health Declaration",
                      style: kMainTextStyle,
                    ),
                    subtitle: Text("Update your latest HDF", style: greyTExt,),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey.shade400,
                    ),
                    onTap: () => Navigator.of(context).pushNamed("/healthDeclaration"),
                  );
                }else {
                  return SizedBox();
                }
              },
            ),
            FutureBuilder(
              future: getStringValuesSF("id_number"),
              initialData: SizedBox(),
              builder: (context, result) {
                if(result.hasData && result.data != null) {
                  return ListTile(
                    title: Text(
                      "Places Visit",
                      style: kMainTextStyle,
                    ),
                    subtitle: Text("View Visited Scanning Point", style: greyTExt,),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey.shade400,
                    ),
                    onTap: () => Navigator.of(context).pushNamed("/placesVisited"),
                  );
                }else {
                  return SizedBox();
                }
              },
            ),
            ListTile(
              title: Text(
                "Tutorial",
                style: kMainTextStyle,
              ),
              subtitle: Text(
                "",
                style: greyTExt,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () => Navigator.of(context).pushNamed("/onBoarding"),
            ),
            ListTile(
              title: Text(
                "Terms and Condition",
                style: kMainTextStyle,
              ),
              subtitle: Text(
                "",
                style: greyTExt,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () => showTermsAndCondition(context),
            ),
            SizedBox(height: 15,),
            ListTile(
              title: Text(
                "Share the App",
                style: kMainTextStyle,
              ),
              onTap: () => onShareWithEmptyOrigin(),
            ),
          ],
        ),
      ),
    );
  }
}
