import 'package:json_annotation/json_annotation.dart';

part 'project_list_response.g.dart';

@JsonSerializable()
class ProjectListResponse {
  @JsonKey(name: 'list')
  List<Project>? projectList;

  ProjectListResponse({this.projectList});

  factory ProjectListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectListResponseToJson(this);
}

@JsonSerializable()
class Project {
  String? id;
  String? name;
  @JsonKey(name: 'project_id')
  String? projectId;
  @JsonKey(name: 'parent_id')
  String? parentId;

  Project({this.id, this.name, this.projectId, this.parentId});

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
