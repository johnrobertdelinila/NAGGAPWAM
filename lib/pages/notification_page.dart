
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/Widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/Widgets/icons.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    getNotification(AsyncSnapshot<QuerySnapshot> snapshot) {
      var int = 0;
      return snapshot.data.docs
          .map((doc){
            int++;
            Timestamp timestamp = doc.get("timestamp");
            return Column(
              children: <Widget>[
                ListTile(
                  onTap: () {},
                  leading: Text(
                    int.toString(),
                    style: TextStyle(
                        color: Colors.black, fontSize: 20),
                  ),
                  title: Text(
                    doc.get("title"),
                    style: TextStyle(
                        color: Colors.black, fontSize: 20),
                  ),
                  subtitle: Text(
                    doc.get("body") +"\n" + Jiffy(timestamp.toDate()).fromNow(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w200),
                  ),
                  trailing: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.virus,
                      color: appColor,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ],
            );
          }).toList();
    }

    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: CustomScrollviewAdaptive(
        icon: notifIn,
        title: "Notification",
        widgets: [
          Container(
            child: FutureBuilder(
              future: getStringValuesSF("token"),
              builder: (context, snap) {
                if(snap.hasData) {
                  if(snap.data != null) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("notifications").where("fcmToken", isEqualTo: snap.data.toString()).snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasData) {
                            if(snapshot.data != null) {
                              if(snapshot.data.docs.length > 0) {
                                return ListView(physics: AlwaysScrollableScrollPhysics(), scrollDirection: Axis.vertical, shrinkWrap: true, children: getNotification(snapshot));
                              }else {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40),
                                    child: Column(
                                      children: [
                                        Icon(!isAndroid ? CupertinoIcons.bell_circle : Icons.notifications_none_outlined, color: Colors.grey.shade400, size: 40,),
                                        Text("No notification", style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 24
                                        ),)
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }else {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text("No notification"),
                                ),
                              );
                            }
                          }else {
                            return Center(
                              child: (!isAndroid ? CupertinoActivityIndicator(
                                animating: true,
                                radius: 20,
                              ) : CircularProgressIndicator()),
                            );
                          }
                        }
                    );
                  }else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No notification"),
                      ),
                    );
                  }
                }else {
                  return Center(
                    child: (!isAndroid ? CupertinoActivityIndicator(
                      animating: true,
                      radius: 20,
                    ) : CircularProgressIndicator()),
                  );
                }
              },
            ),
          )
        ],
      )
    );
  }

}