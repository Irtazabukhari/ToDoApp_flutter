import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todolist = [];
  List<ToDo> _foundtoDo = [];
  final _toDoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todolist = ToDo.todolist(); // Initialize once
    _foundtoDo = todolist;
  }

  @override
  void dispose() {
    _toDoController.dispose(); // Clean up controller
    super.dispose();
  }

  void _handleTodoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todolist.removeWhere((item) => item.id == id);
    });
  }

  void _runFilter(String enteredkeyword) {
    List<ToDo> results = [];
    if (enteredkeyword.isEmpty) {
      results = todolist;
    } else {
      results = todolist
          .where(
            (item) => item.todotext!.toLowerCase().contains(
              enteredkeyword.toLowerCase(),
            ),
          )
          .toList();
    }

    setState(() {
      _foundtoDo = results;
    });
  }

  void _showAddToDoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _toDoController,
              decoration: InputDecoration(
                labelText: 'Add new task',
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addToDoItem,
              icon: Icon(Icons.add),
              label: Text('Add Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: tdBlue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _addToDoItem() {
    String newText = _toDoController.text;
    if (newText.isNotEmpty) {
      setState(() {
        todolist.add(
          ToDo(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            todotext: newText,
          ),
        );
      });
      Navigator.pop(context); // Close the bottom sheet
      _toDoController.clear(); // Clear input field
    }
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, color: tdBlack, size: 30),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/irtaza.png'),
            ),
          ),
        ],
      ),
      backgroundColor: tdBGColor,
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 50, bottom: 20),
                            child: Text(
                              'All ToDos',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: ElevatedButton(
                              onPressed: _showAddToDoBottomSheet,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tdBlue,
                                minimumSize: Size(60, 60),
                                elevation: 5,
                              ),
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (ToDo todoo in _foundtoDo.reversed)
                        ToDoItems(
                          todo: todoo,
                          onToDoChanged: _handleTodoChange,
                          onDelete: () => _deleteToDoItem(todoo.id!),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
