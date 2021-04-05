
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
  };
}