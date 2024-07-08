class Todo {
  final String title;
  final String description;
  final bool completed;
  final String userId;

  const Todo({
    required this.title,
    required this.description,
    required this.completed,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) =>
      Todo(title: json["title"], description: json["description"], completed: false, userId: "");

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "completed": completed,
        "userId": userId,
      };

  Todo copyWith({
    String? title,
    String? description,
    bool? completed,
    String? userId,
  }) =>
      Todo(
        title: title ?? this.title,
        description: description ?? this.description,
        completed: completed ?? this.completed,
        userId: userId ?? this.userId,
      );
}

List<Todo> todos = [];
