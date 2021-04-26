

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/models/scanned.dart';
import 'package:covidcapstone/models/scanning_point.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class VisitedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
              DataCell(
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection("scanning_points").doc(scanned.scanning_point_id).get(),
                  builder: (context, snap) {
                    if(snap.hasData &&  snap.data.exists && snap.data != null) {
                      ScanningPoint scanningPoint = ScanningPoint();
                      scanningPoint.fromSnapshot(snap.data);
                      return Text(scanningPoint.address);
                    }else {
                      return Text("--");
                    }
                  },
                )
              ),
              DataCell(
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection("scanning_points").doc(scanned.scanning_point_id).get(),
                    builder: (context, snap) {
                      if(snap.hasData && snap.data.exists && snap.data != null) {
                        ScanningPoint scanningPoint = ScanningPoint();
                        scanningPoint.fromSnapshot(snap.data);
                        return Text(scanningPoint.establishment);
                      }else {
                        return Text("--");
                      }
                    },
                  )
              ),
              DataCell(Text(temp)),
            ]
        );
      }).toList();
      return newList;
    }

    Widget buildTable() {
      return FutureBuilder(
        future: getStringValuesSF("id_number"),
        builder: (context, snap) {
          if(snap.hasData) {
            if(snap.data != null) {
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("scanned").where("id_number", isEqualTo: snap.data.toString()).orderBy("timestamp").snapshots(),
                  builder: (context, snap) {
                    return SingleChildScrollView(
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
                              'Location',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Establishment',
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
                    );
                  }
              );
            }else {
              return Center(child: Text("Loading"));
            }
          }else {
            return Center(child: Text("Loading"));
          }
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
        title: 'Places Visited',
        widgets: [

          Padding(
            padding: EdgeInsets.all(10),
            child: ButtonTheme(
              minWidth: double.maxFinite,
              height: 58.0,
              child: OutlineButton(
                onPressed: () async {
                  if(isAndroid) {
                    DateTime selectedDate = await getPositiveReportDate(context);
                    if (selectedDate != null) {
                      reportDate = selectedDate;
                    }
                  }
                },
                borderSide: new BorderSide(
                  width: 1.0,
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Text(
                  Jiffy(reportDate.toString()).yMMMMd,
                  style: Theme.of(context).textTheme.button.apply(
                    color: Color(0xFF686868),
                  ),
                ),
              ),
            ),
          ),

          buildTable()
        ],
      ),
    );

  }

}