import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<WorkoutModel> _studentWorkouts = [];
  List<WorkoutModel> _teacherWorkouts = [];
  bool _isLoading = false;

  List<WorkoutModel> get studentWorkouts => _studentWorkouts;
  List<WorkoutModel> get teacherWorkouts => _teacherWorkouts;
  bool get isLoading => _isLoading;

  void clearWorkouts() {
    _studentWorkouts = [];
    _teacherWorkouts = [];
    notifyListeners();
  }

  /// Carrega os treinos prescritos por um professor
  Future<void> fetchWorkoutsForTeacher(String teacherId) async {
    if (teacherId.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("Buscando treinos para o professor: $teacherId");
      var snapshot = await _db
          .collection('treinos')
          .where('teacherId', isEqualTo: teacherId)
          .get();

      _teacherWorkouts = snapshot.docs
          .map((doc) => WorkoutModel.fromMap(doc.id, doc.data()))
          .toList();
      debugPrint("Encontrados ${_teacherWorkouts.length} treinos para o professor.");
    } catch (e) {
      debugPrint("Erro ao buscar treinos do professor: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega em tempo real (Stream) ou via busca única (Future) os treinos do aluno
  Future<void> fetchWorkoutsForStudent(String studentId) async {
    if (studentId.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("Buscando treinos para o aluno: $studentId");
      
      // Criando a lista para o whereIn de forma segura
      List<String> queryIds = [studentId];
      if (studentId != 'geral') {
        queryIds.add('geral');
      }

      var snapshot = await _db
          .collection('treinos')
          .where('studentId', whereIn: queryIds)
          .get();

      _studentWorkouts = snapshot.docs
          .map((doc) => WorkoutModel.fromMap(doc.id, doc.data()))
          .toList();
      debugPrint("Encontrados ${_studentWorkouts.length} treinos para o aluno.");
    } catch (e) {
      debugPrint("Erro ao buscar treinos do aluno: $e");
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

      debugPrint("Salvando treino: ${data['title']} para aluno $studentId");
      await _db.collection('treinos').add(data);
      
      // Recarregar a lista do professor após salvar
      await fetchWorkoutsForTeacher(teacherId);
      
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
