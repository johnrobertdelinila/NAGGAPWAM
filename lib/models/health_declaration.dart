
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthDeclaration {
  bool isHaveSoreThroat = false;
  bool isHaveBodyPain = false;
  bool isHaveHeadache = false;
  bool isHaveFever = false;
  bool isHaveStayed = false;
  bool isHaveContact = false;
  bool isTravelledOutside = false;
  bool isTravelledNCR = false;
  String travelledArea;
  bool haveRead = false;
  Timestamp updatedOn;
  String temperature;

  Map<String, dynamic> toJson() =>
  {
    "isHaveSoreThroat": isHaveSoreThroat,
    "isHaveBodyPain": isHaveBodyPain,
    "isHaveHeadache": isHaveHeadache,
    "isHaveFever": isHaveFever,
    "isHaveStayed": isHaveStayed,
    "isHaveContact": isHaveContact,
    "isTravelledOutside": isTravelledOutside,
    "isTravelledNCR": isTravelledNCR,
    "travelledArea": travelledArea,
    "temperature": temperature,
    'updatedOn': FieldValue.serverTimestamp()
  };

  void fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    this.isHaveSoreThroat = data["isHaveSoreThroat"];
    this.isHaveBodyPain = data["isHaveBodyPain"];
    this.isHaveHeadache = data["isHaveHeadache"];
    this.isHaveFever = data["isHaveFever"];
    this.isHaveStayed = data["isHaveStayed"];
    this.isHaveContact = data["isHaveContact"];
    this.isTravelledOutside = data["isTravelledOutside"];
    this.isTravelledNCR = data["isTravelledNCR"];
    this.travelledArea = data["travelledArea"];
    this.updatedOn = data["updatedOn"];
    this.temperature = data['temperature'];
  }

}