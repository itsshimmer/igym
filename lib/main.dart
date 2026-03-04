import 'package:flutter/material.dart';
import 'package:igym/screens/role_selector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const IGymApp());
}

class IGymApp extends StatelessWidget {
  const IGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iGym',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Você pode alterar a fonte aqui caso use alguma específica do Google Fonts
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF0F0E13),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      // Definindo a tela RoleSelectorScreen como a tela inicial do app
      home: const RoleSelectorScreen(),
    );
  }
}