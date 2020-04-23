import 'package:validicitylib/model/project.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// The different User types. admin can do anything.
enum UserType { admin, validicityclient, user }

@JsonSerializable()
class User {
  int id;

  /// Email for recovery
  String email;

  /// The full name of the user
  String name;

  /// Login name, normally email
  String username;

  DateTime created;
  DateTime modified;

  UserType type;

  /// Last created Recovery code
  // int lastCode; Should never be on client side!

  //Organisation organisation;

  @JsonKey(fromJson: flatten, nullable: true)
  List<Project> userProjects;

  User(this.name, this.email);

  /// Test User type
  bool get isAdmin => type == UserType.admin;
  bool get isValidicityclient => type == UserType.validicityclient;
  bool get isUser => type == UserType.user;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static List<Project> flatten(List list) {
    if (list == null) {
      return null;
    }
    var x = list.map((m) => m['project']);
    return x.map((m) => Project.fromJson(m)).toList();
  }
}
