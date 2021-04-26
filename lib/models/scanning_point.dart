

import 'package:cloud_firestore/cloud_firestore.dart';

class ScanningPoint {
  String email, category, establishment, telephone, address, barangay, lastName, firstName, middleName, mobileNumber, username, password, confirmPassword;

  Map<String, dynamic> toJson() =>
      {
        "email": email,
        "category": category,
        "establishment": establishment,
        "telephone": telephone,
        "address": address,
        "barangay": barangay,
        "lastName": lastName,
        "firstName": firstName,
        "middleName": middleName,
        "username": username,
        "password": password
      };

  bool notComplete() {
    for (var v in toJson().values) {
      if(v == null || v.toString().trim().length == 0) {
        return true;
      }
    }
    return false;
  }

  void fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    this.email = data["email"];
    this.category = data["category"];
    this.establishment = data["establishment"];
    this.telephone = data["telephone"];
    this.address = data["address"];
    this.barangay = data["barangay"];
    this.lastName = data["lastName"];
    this.middleName = data["middleName"];
    this.firstName = data["firstName"];
  }

}