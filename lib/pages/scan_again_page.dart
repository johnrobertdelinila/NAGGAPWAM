
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/models/scanned.dart';
import 'package:covidcapstone/models/scanning_point.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class ScanAgainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget buttonn() {
      return Padding(
        padding: EdgeInsets.all(20),
        child: ButtonTheme(
          minWidth: double.maxFinite,
          height: 58.0,
          child: OutlineButton(
            onPressed: ()  {
              Navigator.of(context).pushNamed("/qrScan");
            },
            borderSide: new BorderSide(
              width: 1.0,
              color:  (isAndroid ? Colors.green : CupertinoColors.activeGreen)
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SCAN",
                  style: Theme.of(context).textTheme.button.apply(
                    color: (isAndroid ? Colors.green : CupertinoColors.activeGreen),
                  ),
                ),
                SizedBox(width: 5,),
                Icon(isAndroid ? Icons.qr_code_scanner_rounded : CupertinoIcons.qrcode_viewfinder, color:  (isAndroid ? Colors.green : CupertinoColors.activeGreen),)
              ],
            ),
          ),
        ),
      );
    }

    DateTime reportDate = DateTime.now();

    List<DataRow> _createRows(QuerySnapshot snapshot) {
      if(snapshot == null || snapshot.docs == null) {
        return List<DataRow>();
      }

      List<DataRow> newList = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        Scanned scanned = Scanned();
        scanned.fromSnapshot(documentSnapshot);

        final f = new DateFormat('yyyy-MM-dd hh:mm');

        var temp = (scanned.hdf["temperature"] != null ? scanned.hdf["temperature"] + "°C" : "");
        return new DataRow(
            cells: [
              DataCell(Text(f.format(scanned.timestamp.toDate()))),
              DataCell(Text(scanned.id_number)),
              DataCell(Text(scanned.status.toUpperCase())),
              DataCell(Text(temp)),
            ]
        );
      }).toList();
      return newList;
    }

    Widget buildTable() {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("scanned")
              .where("scanning_point_id", isEqualTo: FirebaseAuth.instance.currentUser.uid)
              .orderBy("timestamp", descending: true).snapshots(),
          builder: (context, snap) {
            return Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Date',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Temperature',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: _createRows(snap.data),
                ),
              ),
            );
          }
      );
    }

    Future<DateTime> getPositiveReportDate(BuildContext context) {
      Jiffy().subtract(days: 21).yMMMMd;
      return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: Jiffy().subtract(days: 21).dateTime,
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light(),
            child: child,
          );
        },
      );
    }

    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: CustomScrollviewAdaptive(
        title: 'Scanned Citizens',
        widgets: [
          buttonn(),
          buildTable()
        ],
      ),
    );

  }

}