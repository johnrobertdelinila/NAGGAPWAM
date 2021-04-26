

import 'package:cloud_firestore/cloud_firestore.dart';

class Scanned {
  String status;
  String id_number;
  String scanning_point_id;
  Map<String, dynamic> hdf;
  Timestamp timestamp;

  Map<String, dynamic> toJson() =>
  {
    "status": status,
    "id_number" : id_number,
    "hdf": hdf,
    "scanning_point_id": scanning_point_id,
    "timestamp": FieldValue.serverTimestamp()
  };

  void fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    this.status = data["status"];
    this.id_number = data["id_number"];
    this.scanning_point_id = data["scanning_point_id"];
    this.hdf = data["hdf"];
    this.timestamp = data["timestamp"];
  }

}