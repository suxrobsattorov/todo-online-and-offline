import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_task/models/todo.dart';

class Todos with ChangeNotifier {
  List<Todo> _list = [];

  String? _authToken;
  String? _userId;

  final String baseUrl =
      'https://todo-task-private-default-rtdb.firebaseio.com/';

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  List<Todo> get list {
    return [..._list];
  }

  Future<void> getTodosFromFirebase() async {
    final url = Uri.parse('${baseUrl}todos.json?auth=$_authToken');

    try {
      final response = await http.get(url);

      if (jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Todo> loadedTodos = [];
        data.forEach((todoId, todoData) {
          if (todoData['creatorId'] == _userId) {
            loadedTodos.add(
              Todo(
                id: todoId,
                name: todoData['name'],
                description: todoData['description'],
                date: DateTime.parse(todoData['date']),
                isDone: todoData['isDone'],
              ),
            );
          }
        });

        _list = loadedTodos;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo(Todo todo) async {
    final url = Uri.parse('${baseUrl}todos.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'name': todo.name,
            'description': todo.description,
            'date': todo.date.toString(),
            'isDone': todo.isDone,
            'creatorId': _userId,
          },
        ),
      );

      final name = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newTodo = Todo(
        id: name,
        name: todo.name,
        description: todo.description,
        date: todo.date,
        isDone: todo.isDone,
      );
      _list.add(newTodo);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    final todoIndex = _list.indexWhere(
      (todo) => todo.id == updatedTodo.id,
    );
    if (todoIndex >= 0) {
      final url =
          Uri.parse('${baseUrl}todos/${updatedTodo.id}.json?auth=$_authToken');
      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'name': updatedTodo.name,
              'description': updatedTodo.description,
              'date': updatedTodo.date.toString(),
              'isDone': updatedTodo.isDone,
            },
          ),
        );
        _list[todoIndex] = updatedTodo;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> updateTodoIsDone(String id) async {
    final todoIndex = _list.indexWhere(
      (todo) => todo.id == id,
    );
    if (todoIndex >= 0) {
      final url = Uri.parse('${baseUrl}todos/$id.json?auth=$_authToken');
      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'isDone': !_list[todoIndex].isDone,
            },
          ),
        );
        getTodosFromFirebase();
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteTodo(String id) async {
    final url = Uri.parse('${baseUrl}todos/$id.json?auth=$_authToken');

    try {
      var deletingTodo = _list.firstWhere((todo) => todo.id == id);
      final todoIndex = _list.indexWhere((todo) => todo.id == id);
      _list.removeWhere((todo) => todo.id == id);
      notifyListeners();

      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _list.insert(todoIndex, deletingTodo);
        notifyListeners();
        throw const HttpException('Kechirasiz, o\'chirishda xatolik');
      }
    } catch (e) {
      rethrow;
    }
  }

  Todo findById(String todoId) {
    return _list.firstWhere((todo) => todo.id == todoId);
  }
}
