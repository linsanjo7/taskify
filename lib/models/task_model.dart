class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final int createdAt;
  final List<String> sharedWith;  // emails of users

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.sharedWith,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "completed": completed,
    "createdAt": createdAt,
    "sharedWith": sharedWith,
  };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
    id: map["id"],
    title: map["title"],
    description: map["description"],
    completed: map["completed"],
    createdAt: map["createdAt"],
    sharedWith: List<String>.from(map["sharedWith"]),
  );

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    int? createdAt,
    List<String>? sharedWith,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }
}
