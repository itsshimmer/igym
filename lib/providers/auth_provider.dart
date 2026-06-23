import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  String? _userRole; // 'aluno' ou 'professor'
  bool _isLoading = false;

  User? get user => _user;
  String? get userRole => _userRole;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Escuta mudanças no estado de login automaticamente ao iniciar o app
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _fetchUserRole(user.uid);
      } else {
        _userRole = null;
      }
      notifyListeners(); // Avisa as telas para se reconstruírem
    });
  }

  Future<void> _fetchUserRole(String uid) async {
    try {
      var doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        _userRole = doc.data()?['role'];
      }
    } catch (e) {
      debugPrint("Erro ao buscar role do usuário: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      debugPrint("Erro no login: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}