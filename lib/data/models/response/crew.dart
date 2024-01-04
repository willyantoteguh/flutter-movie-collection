class CrewResponse {
  int? id;
  List<Crew>? crew;

  CrewResponse({this.id, this.crew});

  CrewResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['crew'] != null) {
      crew = <Crew>[];
      json['crew'].forEach((v) {
        if (v["job"].toString().toLowerCase() == "director") {
          crew!.add(Crew.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (crew != null) {
      data['crew'] = crew!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Crew {
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  String? department;
  String? job;

  Crew(
      {this.id,
      this.knownForDepartment,
      this.name,
      this.originalName,
      this.department,
      this.job});

  Crew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    department = json['department'];
    job = json['job'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['known_for_department'] = knownForDepartment;
    data['name'] = name;
    data['original_name'] = originalName;
    data['department'] = department;
    data['job'] = job;
    return data;
  }
}
