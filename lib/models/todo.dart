class Todo {
  final String title;
  final String description;
  final bool completed;
  final String id;

  const Todo({
    required this.title,
    required this.description,
    required this.completed,
    required this.id,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json["title"],
        description: json["description"],
        completed: false,
        id: ""
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "completed": completed,
        "id": id,
      };

  Todo copyWith({
    String? title,
    String? description,
    bool? completed,
    String? id,
  }) =>
      Todo(
        title: title ?? this.title,
        description: description ?? this.description,
        completed: completed ?? this.completed,
        id: id ?? this.id,
      );
}

List<Todo> todos = [];
