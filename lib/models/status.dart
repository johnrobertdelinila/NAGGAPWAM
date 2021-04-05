
import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  String id, phoneNumber;
  DateTime birthday;

  Status() {
    DateTime now = DateTime.now();
    this.birthday = DateTime(now.year, now.month, now.day);
  }

  Map<String, dynamic> toJson() =>
  {
    "id": id,
    "phoneNumber": phoneNumber,
    "birthday": birthday
  };

  bool notComplete() {
    for (var v in toJson().values) {
      if(v == null || v.toString().trim().length == 0) {
        return true;
      }
    }
    return false;
  }

}