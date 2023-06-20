import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Lista de Tarefas",
    theme: ThemeData.dark(),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController todoController = TextEditingController();

  List _toDoList = [];

  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo['title'] = todoController.text;
      todoController.text = '';
      newTodo['ok'] = false;
      _toDoList.add(newTodo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ListaDeTarefas",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    // Input Text
                    decoration: InputDecoration(
                        labelText: 'Nova tarefa',
                        labelStyle: TextStyle(color: Colors.lightBlue)),
                    controller: todoController,
                  ),
                ),
                ElevatedButton(
                    onPressed: _addToDo,
                    child: Text(
                      'ADD',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.lightBlue))),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(_toDoList[index]['title']),
                      value: _toDoList[index]['ok'],
                      secondary: CircleAvatar(
                        child: Icon(
                            _toDoList[index]['ok'] ? Icons.check : Icons.error,
                            color: _toDoList[index]['ok']
                                ? Colors.green
                                : Colors.white),
                        backgroundColor: Colors.blue,
                      ),
                      onChanged: (e) {
                        setState(() {
                          _toDoList[index]['ok'] = e;
                          _saveData();
                        });
                      },
                    );
                  }))
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File("${directory.path}/data.json");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return '';
    }
  }
}
