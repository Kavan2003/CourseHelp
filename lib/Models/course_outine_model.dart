class Module {
  final String title;
  final String description;
  final int duration;
  bool isAccepted;

  Module({
    required this.title,
    required this.description,
    required this.duration,
    this.isAccepted = false,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
    };
  }
}

class Course {
  final String title;
  final String description;
  final List<Module> modules;

  Course({
    required this.title,
    required this.description,
    required this.modules,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var modulesJson = json['modules'] as List;
    List<Module> modulesList =
        modulesJson.map((i) => Module.fromJson(i)).toList();

    return Course(
      title: json['title'],
      description: json['description'],
      modules: modulesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }
}
