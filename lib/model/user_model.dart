// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? days;
  String? email;
  String? id;
  int? money;
  List<double>? moneyHistory;
  String? noOfDays;
  String? profilePicture;
  String? totalmoney;
  String? username;

  UserModel({
    this.days,
    this.email,
    this.id,
    this.money,
    this.moneyHistory,
    this.noOfDays,
    this.profilePicture,
    this.totalmoney,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        days: json["days"],
        email: json["email"],
        id: json["id"],
        money: json["money"],
        moneyHistory: json["moneyHistory"] == null
            ? []
            : List<double>.from(json["moneyHistory"]!.map((x) => x)),
        noOfDays: json["no_of_days"],
        profilePicture: json["profilePicture"],
        totalmoney: json["totalmoney"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "days": days,
        "email": email,
        "id": id,
        "money": money,
        "moneyHistory": moneyHistory == null
            ? []
            : List<dynamic>.from(moneyHistory!.map((x) => x)),
        "no_of_days": noOfDays,
        "profilePicture": profilePicture,
        "totalmoney": totalmoney,
        "username": username,
      };
}
