
import 'package:cloud_firestore/cloud_firestore.dart';

class Citizen {
  String lastname, firstname, middlename, gender, phoneNumber, email, barangay, contact_person, relationship,
      contact_person_number, contact_person_address, id;
  DateTime birthday;

  Citizen() {
    DateTime now = DateTime.now();
    this.birthday = DateTime(now.year, now.month, now.day);
  }

  Map<String, dynamic> toJson() =>
  {
    "lastname": lastname,
    "firstname": firstname,
    "middlename": middlename,
    "gender": gender,
    "phoneNumber": phoneNumber,
    "email": email,
    "barangay": barangay,
    "contact_person": contact_person,
    "relationship": relationship,
    "contact_person_number": contact_person_number,
    "contact_person_address": contact_person_address,
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

  void fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    this.firstname = data["firstname"];
    this.lastname = data["lastname"];
    this.middlename = data["middlename"];
    this.gender = data["gender"];
    this.email = data["email"];
    this.barangay = data["barangay"];
    this.contact_person = data["contact_person"];
    this.relationship = data["relationship"];
    this.contact_person_number = data["contact_person_number"];
    this.contact_person_address = data["contact_person_address"];
    this.phoneNumber = data["phoneNumber"];
    this.birthday = data["birthday"].toDate();
    this.id = snapshot.id;
  }

}