import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  String? _userRole; // 'aluno' ou 'professor'
  String? _userName;
  String? _teacherId; // Se for aluno, guarda o ID do professor
  bool _isLoading = false;

  User? get user => _user;
  String? get userRole => _userRole;
  String? get userName => _userName;
  String? get teacherId => _teacherId;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _fetchUserData(user.uid);
      } else {
        _userRole = null;
        _userName = null;
        _teacherId = null;
      }
      notifyListeners();
    });
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      var doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        _userRole = data?['role'];
        _userName = data?['nome'];
        _teacherId = data?['teacherId'];
      }
    } catch (e) {
      debugPrint("Erro ao buscar dados do usuário: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (res.user != null) {
        await _fetchUserData(res.user!.uid);
      }
      return true;
    } catch (e) {
      debugPrint("Erro no login: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String nome,
    required String role,
    String? especialidade,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential res =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = res.user;

      if (user != null) {
        Map<String, dynamic> userData = {
          'nome': nome,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        };

        if (role == 'professor' && especialidade != null) {
          userData['especialidade'] = especialidade;
        }

        await _db.collection('usuarios').doc(user.uid).set(userData);
        await _fetchUserData(user.uid);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Erro no cadastro: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _userRole = null;
    _userName = null;
    _teacherId = null;
    notifyListeners();
  }

  /// Busca todos os professores cadastrados
  Future<List<Map<String, dynamic>>> fetchTeachers() async {
    try {
      var snapshot = await _db
          .collection('usuarios')
          .where('role', isEqualTo: 'professor')
          .get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint("Erro ao buscar professores: $e");
      return [];
    }
  }

  /// Vincula o aluno atual a um professor
  Future<bool> linkStudentToTeacher(String teacherId) async {
    if (_user == null) return false;
    try {
      await _db.collection('usuarios').doc(_user!.uid).update({
        'teacherId': teacherId,
      });
      _teacherId = teacherId;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Erro ao vincular professor: $e");
      return false;
    }
  }

  /// Busca os alunos vinculados a um professor
  Future<List<Map<String, dynamic>>> fetchStudentsForTeacher(String teacherId) async {
    try {
      var snapshot = await _db
          .collection('usuarios')
          .where('role', isEqualTo: 'aluno')
          .where('teacherId', isEqualTo: teacherId)
          .get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint("Erro ao buscar alunos do professor: $e");
      return [];
    }
  }

  /// Busca dados de um professor específico
  Future<Map<String, dynamic>?> fetchUserDataById(String uid) async {
    try {
      var doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
    } catch (e) {
      debugPrint("Erro ao buscar dados do usuário $uid: $e");
    }
    return null;
  }

  /// Atualiza o perfil do usuário atual
  Future<bool> updateUserProfile({
    required String nome,
    String? especialidade,
  }) async {
    if (_user == null) return false;
    try {
      _isLoading = true;
      notifyListeners();

      Map<String, dynamic> updateData = {
        'nome': nome,
      };
      if (especialidade != null) {
        updateData['especialidade'] = especialidade;
      }

      await _db.collection('usuarios').doc(_user!.uid).update(updateData);
      await _fetchUserData(_user!.uid);
      return true;
    } catch (e) {
      debugPrint("Erro ao atualizar perfil: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}