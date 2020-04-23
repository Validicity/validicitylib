import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  int id;

  String name;
  String description;

  DateTime created;
  DateTime modified;

  Project(this.name);

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
