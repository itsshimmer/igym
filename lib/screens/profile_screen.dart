import 'package:flutter/material.dart';
import 'package:igym/providers/auth_provider.dart';
import 'package:igym/screens/select_teacher.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;

  bool _isSaving = false;
  bool _isLoadingDoc = true;
  Map<String, dynamic>? _teacherData;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.userName ?? '');
    _specialtyController = TextEditingController();

    _loadAdditionalUserData();
  }

  Future<void> _loadAdditionalUserData() async {
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      final docData = await auth.fetchUserDataById(auth.user!.uid);
      if (mounted && docData != null) {
        setState(() {
          if (docData['especialidade'] != null) {
            _specialtyController.text = docData['especialidade'];
          }
        });
      }

      if (auth.userRole == 'aluno' && auth.teacherId != null) {
        final teacher = await auth.fetchUserDataById(auth.teacherId!);
        if (mounted) {
          setState(() {
            _teacherData = teacher;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoadingDoc = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final auth = context.read<AuthProvider>();
    final isTeacher = auth.userRole == 'professor';

    final success = await auth.updateUserProfile(
      nome: _nameController.text.trim(),
      especialidade: isTeacher ? _specialtyController.text.trim() : null,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Color(0xFF65C48C),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar perfil. Tente novamente.'),
            backgroundColor: Color(0xFFE55353),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.userName ?? 'Usuário';
    final userEmail = auth.user?.email ?? 'Sem e-mail';
    final userRole = auth.userRole ?? 'aluno';
    final isTeacher = userRole == 'professor';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0E13),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoadingDoc
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF8C52FF)))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Avatar Card
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8C52FF),
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF8C52FF).withValues(alpha: 0.3),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF16161A),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF28282D)),
                                    ),
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      color: Color(0xFF8C52FF),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E1A4E),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(isTeacher ? '👩‍🏫' : '🏋️',
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Text(
                                    userRole.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF8C52FF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      const Text(
                        'INFORMAÇÕES PESSOAIS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nome
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          labelStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF8C52FF)),
                          filled: true,
                          fillColor: const Color(0xFF16161A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF28282D)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF28282D)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF8C52FF)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, informe seu nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // E-mail (Disabled)
                      TextFormField(
                        initialValue: userEmail,
                        enabled: false,
                        style: TextStyle(color: Colors.grey.shade400),
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                          filled: true,
                          fillColor: const Color(0xFF16161A).withValues(alpha: 0.6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF28282D)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF28282D)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Especialidade (Professor)
                      if (isTeacher) ...[
                        TextFormField(
                          controller: _specialtyController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Especialidade',
                            hintText: 'Ex: Musculação, Funcional, Crossfit',
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            labelStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon:
                                const Icon(Icons.workspace_premium_outlined, color: Color(0xFF8C52FF)),
                            filled: true,
                            fillColor: const Color(0xFF16161A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF28282D)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF28282D)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF8C52FF)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Professor Vinculado (Aluno)
                      if (!isTeacher) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'PROFESSOR VINCULADO',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16161A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF28282D)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E1A4E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(Icons.person_pin_rounded,
                                      color: Color(0xFF8C52FF), size: 24),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _teacherData != null
                                          ? (_teacherData!['nome'] ?? 'Professor')
                                          : 'Nenhum professor',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _teacherData != null
                                          ? (_teacherData!['especialidade'] ?? 'Instrutor')
                                          : 'Selecione um professor para receber treinos',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SelectTeacherScreen(),
                                    ),
                                  );
                                  _loadAdditionalUserData();
                                },
                                child: Text(
                                  _teacherData != null ? 'Trocar' : 'Selecionar',
                                  style: const TextStyle(
                                    color: Color(0xFF8C52FF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 36),

                      // Botão Salvar Alterações
                      ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C52FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Salvar Alterações',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
