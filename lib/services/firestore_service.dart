import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final _tasksRef = _db.collection('tasks');

  // CREAR una nueva tarea
  Future<void> addTask({
    required String title,
    String description = '',
  }) async {
    await _tasksRef.add({
      'title': title.trim(),
      'description': description.trim(),
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // LEER todas las tareas en tiempo real
  Stream<List<Task>> streamTasks() {
    return _tasksRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    });
  }

  // ACTUALIZAR estado (completada / pendiente)
  Future<void> toggleTask(String taskId, bool isCompleted) async {
    await _tasksRef.doc(taskId).update({
      'isCompleted': isCompleted,
      'completedAt': isCompleted ? FieldValue.serverTimestamp() : null,
    });
  }

  // ELIMINAR una tarea
  Future<void> deleteTask(String taskId) async {
    await _tasksRef.doc(taskId).delete();
  }
}