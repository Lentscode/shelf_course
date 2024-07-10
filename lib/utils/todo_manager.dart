part of "utils.dart";

class TodoManager {
  // Funzione per creare un todo, usando i dati mandati dall'utente.
  static Todo createTodo(Map<String, dynamic> data, String userId) {
    final Todo todo = Todo.fromJson(data).copyWith(userId: userId);
    todos.add(todo);
    return todo;
  }

  // Funzione per cercare i todo di un utente.
  static List<Todo> getTodosOfUser(String userId) => todos.where((todo) => todo.userId == userId).toList();

  // Funzione per cercare un todo di un utente con un determinato titolo.
  static Todo? getTodoByTitle(String title, String userId) {
    final todo = todos.firstWhereOrNull((todo) => todo.title == title && todo.userId == userId);
    return todo;
  }

  // Funzione per eliminare un todo.
  static void deleteTodo(Todo todo) => todos.remove(todo);

  static Todo completeTodo(Todo oldTodo) {
    // Accediamo all'indice di questo todo per sostituirlo con uno nuovo
    // con `completed = true`.
    final todoIndex = todos.indexOf(oldTodo);
    final newTodo = oldTodo.copyWith(completed: true);
    todos.insert(todoIndex, newTodo);

    return newTodo;
  }
}
