import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_model.dart';

class TaskProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<Task> tasks = [];
  bool isLoading = true;

  TaskProvider() {
    _db.collection('tasks').orderBy('dueDate').snapshots().listen((snapshot) {
      tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
      isLoading = false;
      notifyListeners();
    });
  }

  // Backend API base URL
  final String apiUrl = 'https://scalaxity-be.onrender.com/tasks';

  Future<void> addTask(Task task) async {
    // Add to backend
    await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toMap()),
    );
    // Add to Firestore
    await _db.collection('tasks').add(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    if (task.id == null) return;
    // Update backend
    await http.put(
      Uri.parse('$apiUrl/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toMap()),
    );
    // Update Firestore
    await _db.collection('tasks').doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    // Delete from backend
    await http.delete(Uri.parse('$apiUrl/$id'));
    // Delete from Firestore
    await _db.collection('tasks').doc(id).delete();
  }
}
