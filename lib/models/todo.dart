// Questa classe ci aiuta nel gestire i todo all'interno del server,
// per crearli, mostrarli all'utente e salvarli nella lista [todos].
class Todo {
  // Titolo del todo.
  final String title;
  // Descrizione del todo.
  final String description;
  // Se il todo è stato completato o no.
  final bool completed;
  // Id dell'utente che ha creato il todo.
  final String userId;

  const Todo({
    required this.title,
    required this.description,
    required this.completed,
    required this.userId,
  });

  // Costruttore per creare un todo da un json. Ci servirà quando l'utente inserirà i dati
  // per creare il todo. 
  //. Settiamo [completed] a `false` e [userId] a una stringa vuota. Quest'ultima la
  //. setteremo dopo la creazione.
  factory Todo.fromJson(Map<String, dynamic> json) =>
      Todo(title: json["title"], description: json["description"], completed: false, userId: "");

  // Metodo per trasformare il todo in un JSON, utile per mandarlo come risposta all'utente.
  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "completed": completed,
        "userId": userId,
      };

  // Metodo per creare una copia del todo, ma con proprietà modificabili tramite parametri.
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

// Lista dei todo immagazzinati nel server.
List<Todo> todos = [];
