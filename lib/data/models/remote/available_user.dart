class AvailableContacts {
  bool flag;
  List<MatchingContact> matchingContacts;

  AvailableContacts({
    required this.flag,
    required this.matchingContacts,
  });

  factory AvailableContacts.fromJson(Map<String, dynamic> json) =>
      AvailableContacts(
        flag: json["flag"],
        matchingContacts: List<MatchingContact>.from(
            json["matchingContacts"].map((x) => MatchingContact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag,
        "matchingContacts":
            List<dynamic>.from(matchingContacts.map((x) => x.toJson())),
      };
}

class MatchingContact {
  String id;
  String? name;
  String number;
  String fcmToken;
  String? photo;

  MatchingContact({
    required this.id,
    required this.name,
    required this.number,
    required this.fcmToken,
    required this.photo,
  });

  factory MatchingContact.fromJson(Map<String, dynamic> json) =>
      MatchingContact(
        id: json["_id"],
        name: json["name"],
        number: json["number"],
        fcmToken: json["fcmToken"],
        photo: json["avater"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "number": number,
        "fcmToken": fcmToken,
        "photo": photo,
      };
}