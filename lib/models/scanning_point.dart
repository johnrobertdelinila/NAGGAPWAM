

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

}