class ToDo {
  String? id;
  String? todotext;
  bool isDone;

  ToDo({required this.id, required this.todotext, this.isDone = false});

  static List<ToDo> todolist() {
    return [
      ToDo(id: '01', todotext: 'Buy milk', isDone: true),
      ToDo(id: '02', todotext: 'Buy eggs', isDone: true),
      ToDo(id: '03', todotext: 'Workout'),
      ToDo(id: '04', todotext: 'Eat Food'),
      ToDo(id: '05', todotext: 'Work on Coding'),
      ToDo(id: '06', todotext: 'Play Video Games'),
      ToDo(id: '07', todotext: 'Sleep'),
      ToDo(id: '08', todotext: 'Being Kind'),
      ToDo(id: '09', todotext: 'Sleep'),
    ];
  }
}
