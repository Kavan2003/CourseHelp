class Lessons {
  String title;
  String description;
  int duration;
  List<Submodule> submodules;

  Lessons({
    required this.title,
    required this.description,
    required this.duration,
    required this.submodules,
  });

  factory Lessons.fromJson(Map<String, dynamic> json) {
    return Lessons(
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      submodules: List<Submodule>.from(
          json['modules'].map((x) => Submodule.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
      'modules': List<dynamic>.from(submodules.map((x) => x.toJson())),
    };
  }
}

class Submodule {
  int submoduleNumber;
  String submoduleTitle;
  int submoduleDuration;
  List<Subsubmodule> subsubmodules;

  Submodule({
    required this.submoduleNumber,
    required this.submoduleTitle,
    required this.submoduleDuration,
    required this.subsubmodules,
  });

  factory Submodule.fromJson(Map<String, dynamic> json) {
    return Submodule(
      submoduleNumber: json['module_number'],
      submoduleTitle: json['module_title'],
      submoduleDuration: json['module_duration'],
      subsubmodules: List<Subsubmodule>.from(
          json['submodules'].map((x) => Subsubmodule.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module_number': submoduleNumber,
      'module_title': submoduleTitle,
      'module_duration': submoduleDuration,
      'submodules': List<dynamic>.from(subsubmodules.map((x) => x.toJson())),
    };
  }
}

class Subsubmodule {
  double subsubmoduleNumber;
  String subsubmoduleTitle;
  int subsubmoduleDuration;
  String content;
  String diagram;

  Subsubmodule({
    required this.subsubmoduleNumber,
    required this.subsubmoduleTitle,
    required this.subsubmoduleDuration,
    required this.content,
    required this.diagram,
  });

  factory Subsubmodule.fromJson(Map<String, dynamic> json) {
    return Subsubmodule(
      subsubmoduleNumber: json['submodule_number'],
      subsubmoduleTitle: json['submodule_title'],
      subsubmoduleDuration: json['submodule_duration'],
      content: json['content'],
      diagram: json['Diagram'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submodule_number': subsubmoduleNumber,
      'submodule_title': subsubmoduleTitle,
      'submodule_duration': subsubmoduleDuration,
      'content': content,
      'Diagram': diagram,
    };
  }
}
