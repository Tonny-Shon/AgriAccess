
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String firstname;
  String lastname;
  final String username;
  final String password;
  String phoneNumber;
  String profilePic;
  String role;

  UserModel(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.username,
      required this.password,
      required this.phoneNumber,
      required this.profilePic,
      required this.role});

  String get fullname => '$firstname $lastname';
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static List<String> nameParts(fullname) => fullname.split(' ');

  static String generateUsername(fullname) {
    List<String> nameParts = fullname.split(' ');
    String firstname = nameParts[0].toLowerCase();
    String lastname = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = '$firstname$lastname';
    String usernameWithPrefix = 'user_$camelCaseUsername';

    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
      id: '',
      firstname: '',
      lastname: '',
      username: '',
      password: '',
      phoneNumber: '',
      profilePic: '',
      role: '');

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstname,
      'LastName': lastname,
      'UserName': username,
      'Password': password,
      'ProfilePic': profilePic,
      'Role': role,
      'PhoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
          id: document.id,
          firstname: data['FirstName'] ?? "",
          lastname: data['LastName'] ?? "",
          username: data['UserName'] ?? "",
          password: data['Password'] ?? "",
          phoneNumber: data['PhoneNumber'] ?? "",
          profilePic: data['ProfilePic'] ?? "",
          role: data['Role'] ?? "");
    } else {
      throw Exception('Document data is null');
    }
  }
}
