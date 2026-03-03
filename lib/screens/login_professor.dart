import 'package:flutter/material.dart';
import 'package:igym/screens/teacher_dashboard.dart';

class LoginProfessorScreen extends StatelessWidget {
  const LoginProfessorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Botão Voltar
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Voltar',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Logo do Professor (Ícone de graduação, sem rotação)
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8C52FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Título e Subtítulo
              const Center(
                child: Text(
                  'Entrar como Professor',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Bem-vindo de volta ao iGym!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Indicador "Acesso de Professor"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF16161A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF28282D)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8C52FF), // Destaquei a bolinha com roxo para diferenciar
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Acesso de Professor',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Campo E-mail
              const CustomInputField(
                label: 'E-mail',
                hintText: 'seu@email.com',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              // Campo Senha
              const CustomInputField(
                label: 'Senha',
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 12),

              // Esqueceu a senha
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    color: const Color(0xFF8C52FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botão Entrar
              ElevatedButton(
                onPressed: () {
                  // TODO: Lógica de Login do Professor

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherDashboardScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C52FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Divisor "ou"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade800)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ou',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade800)),
                ],
              ),
              const SizedBox(height: 24),

              // Botão Entrar com Google
              OutlinedButton(
                onPressed: () {
                  // TODO: Lógica de Login com Google
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF28282D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xFF16161A),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'Entrar com Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Footer "Não tem conta?"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem conta? ',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navegar para cadastro de professor
                    },
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(
                        color: Color(0xFF8C52FF),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Como o CustomInputField é o mesmo da tela do Aluno,
/// em um projeto real você pode mover essa classe para um arquivo
/// separado (ex: widgets/custom_input_field.dart) e importar nas duas telas!
class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500),
            suffixIcon: isPassword
                ? Icon(Icons.visibility_off_outlined, color: Colors.grey.shade500)
                : null,
            filled: true,
            fillColor: const Color(0xFF16161A),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF28282D)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF28282D)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8C52FF)),
            ),
          ),
        ),
      ],
    );
  }
}