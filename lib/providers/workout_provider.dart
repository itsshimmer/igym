import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<WorkoutModel> _studentWorkouts = [];
  bool _isLoading = false;

  List<WorkoutModel> get studentWorkouts => _studentWorkouts;
  bool get isLoading => _isLoading;

  /// Carrega em tempo real (Stream) ou via busca única (Future) os treinos do aluno
  Future<void> fetchWorkoutsForStudent(String studentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      var snapshot = await _db
          .collection('treinos')
          .where('studentId', isEqualTo: studentId)
          .get();

      _studentWorkouts = snapshot.docs
          .map((doc) => WorkoutModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Erro ao buscar treinos: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Prescreve um novo treino salvando no Firestore
  Future<bool> prescribeWorkout(String teacherId, String studentId, WorkoutModel workout) async {
    try {
      _isLoading = true;
      notifyListeners();

      Map<String, dynamic> data = workout.toMap();
      data['teacherId'] = teacherId;
      data['studentId'] = studentId;
      data['createdAt'] = FieldValue.serverTimestamp();

      await _db.collection('treinos').add(data);
      return true;
    } catch (e) {
      debugPrint("Erro ao salvar treino: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}