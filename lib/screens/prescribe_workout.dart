import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:igym/models/workout_model.dart';
import 'package:igym/providers/auth_provider.dart';
import 'package:igym/providers/workout_provider.dart';
import 'package:igym/screens/teacher_dashboard.dart';
import 'package:provider/provider.dart';

class PrescribeWorkoutScreen extends StatefulWidget {
  final String? studentId;

  const PrescribeWorkoutScreen({super.key, this.studentId});

  @override
  State<PrescribeWorkoutScreen> createState() => _PrescribeWorkoutScreenState();
}

class _PrescribeWorkoutScreenState extends State<PrescribeWorkoutScreen> {
  final int _selectedIndex = 1;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _category = 'Musculação';
  String _level = 'Intermediário';
  String _duration = '60 min';
  String? _selectedStudentId;

  List<Map<String, dynamic>> _myStudents = [];

  final List<Map<String, dynamic>> _exercises = [
    _createEmptyExercise(),
  ];

  static Map<String, dynamic> _createEmptyExercise() {
    return {
      'name': '',
      'muscleGroup': '',
      'sets': '',
      'reps': '',
      'observations': '',
      'steps': [''],
      'videoUrl': '',
      'isExpanded': true,
    };
  }

  @override
  void initState() {
    super.initState();
    _selectedStudentId = widget.studentId;
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      final students = await auth.fetchStudentsForTeacher(auth.user!.uid);
      if (mounted) {
        setState(() {
          _myStudents = students;
          // Se não veio studentId via construtor e temos alunos, podemos pré-selecionar ou deixar nulo
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addExercise() {
    setState(() {
      _exercises.add(_createEmptyExercise());
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _addStep(int exerciseIndex) {
    setState(() {
      _exercises[exerciseIndex]['steps'].add('');
    });
  }

  void _updateStep(int exerciseIndex, int stepIndex, String value) {
    _exercises[exerciseIndex]['steps'][stepIndex] = value;
  }

  bool get _isFormValid {
    return _titleController.text.isNotEmpty &&
        _exercises.every((e) => e['name'].toString().isNotEmpty) &&
        _selectedStudentId != null;
  }

  Future<void> _saveWorkout() async {
    final authProvider = context.read<AuthProvider>();
    final workoutProvider = context.read<WorkoutProvider>();

    if (authProvider.user == null || _selectedStudentId == null) return;

    final workout = WorkoutModel(
      id: '',
      title: _titleController.text,
      description: _descriptionController.text,
      category: _category,
      level: _level,
      duration: _duration,
      exercises: _exercises,
    );

    final success = await workoutProvider.prescribeWorkout(
      authProvider.user!.uid,
      _selectedStudentId!,
      workout,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treino salvo com sucesso!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TeacherDashboardScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar treino.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<WorkoutProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildStudentSelector(),
                    const SizedBox(height: 24),
                    _buildWorkoutInfoSection(),
                    const SizedBox(height: 32),
                    Text(
                      'Exercícios (${_exercises.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._exercises.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildExerciseCard(entry.key),
                      );
                    }),
                    _buildAddExerciseButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0E13),
                border: Border(top: BorderSide(color: Colors.grey.shade900)),
              ),
              child: ElevatedButton(
                onPressed: (_isFormValid && !isLoading) ? _saveWorkout : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C52FF),
                  disabledBackgroundColor: const Color(0xFF16161A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        _selectedStudentId == null
                            ? 'Selecione um aluno'
                            : _titleController.text.isEmpty
                                ? 'Informe o título do treino'
                                : 'Salvar Treino',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isFormValid ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildStudentSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aluno *',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStudentId,
          hint: const Text('Selecione para quem é o treino',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          dropdownColor: const Color(0xFF1E1433),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF16161A),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          items: [
            const DropdownMenuItem(value: 'geral', child: Text('Todos os Alunos (Geral)')),
            ..._myStudents.map((student) {
              return DropdownMenuItem(
                value: student['id'],
                child: Text(student['nome'] ?? 'Aluno'),
              );
            }),
          ],
          onChanged: (val) => setState(() => _selectedStudentId = val),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: const Color(0xFF16161A),
        indicatorColor: const Color(0xFF2E1A4E),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
                color: Color(0xFF8C52FF), fontSize: 12, fontWeight: FontWeight.w600);
          }
          return TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500);
        }),
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const TeacherDashboardScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF8C52FF)),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_rounded, color: Colors.grey),
            selectedIcon: Icon(Icons.add_rounded, color: Color(0xFF8C52FF)),
            label: 'Prescrever',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.settings_rounded, color: Color(0xFF8C52FF)),
            label: 'Config',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TeacherDashboardScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1433),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prescrever Treino',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Crie um treino completo para seus alunos',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.description_outlined, color: Color(0xFF8C52FF), size: 20),
            SizedBox(width: 8),
            Text(
              'Informações do Treino',
              style: TextStyle(
                color: Color(0xFF8C52FF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildLabeledTextField(
          label: 'Título do Treino *',
          hint: 'Ex: Treino A – Peito e Tríceps',
          controller: _titleController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        _buildLabeledTextField(
          label: 'Descrição',
          hint: 'Descreva o objetivo e orientações gerais do treino...',
          controller: _descriptionController,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildLabeledDropdown(
                label: 'Categoria',
                value: _category,
                items: ['Musculação', 'Funcional', 'Cardio'],
                onChanged: (val) => setState(() => _category = val!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLabeledDropdown(
                label: 'Nível',
                value: _level,
                items: ['Iniciante', 'Intermediário', 'Avançado'],
                onChanged: (val) => setState(() => _level = val!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildLabeledDropdown(
          label: 'Duração',
          value: _duration,
          items: ['30 min', '45 min', '60 min', '90 min'],
          onChanged: (val) => setState(() => _duration = val!),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(int index) {
    final exercise = _exercises[index];
    final bool isExpanded = exercise['isExpanded'] ?? true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: exercise['name'].isEmpty ? const Color(0xFF28282D) : const Color(0xFF3A2460),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXERCÍCIO ${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFF8C52FF),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise['name'].isEmpty ? 'Sem nome' : exercise['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_exercises.length > 1)
                GestureDetector(
                  onTap: () => _removeExercise(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE55353).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.delete_outline_rounded, color: Color(0xFFE55353), size: 20),
                  ),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => exercise['isExpanded'] = !isExpanded),
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          if (isExpanded) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildLabeledTextField(
                    label: 'Nome do Exercício *',
                    hint: 'Ex: Supino Reto',
                    initialValue: exercise['name'],
                    onChanged: (val) => setState(() => exercise['name'] = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildLabeledTextField(
                    label: 'Grupo Muscular',
                    hint: 'Peito',
                    initialValue: exercise['muscleGroup'],
                    onChanged: (val) => exercise['muscleGroup'] = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledTextField(
                    label: 'Séries',
                    hint: '3',
                    initialValue: exercise['sets'],
                    onChanged: (val) => exercise['sets'] = val,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLabeledTextField(
                    label: 'Repetições',
                    hint: '12',
                    initialValue: exercise['reps'],
                    onChanged: (val) => exercise['reps'] = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabeledTextField(
              label: 'Descrição / Observações',
              hint: 'Dicas, cuidados, variações, carga sugerida...',
              maxLines: 3,
              icon: Icons.edit_note_rounded,
              initialValue: exercise['observations'],
              onChanged: (val) => exercise['observations'] = val,
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.format_list_bulleted_rounded, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Como Executar (passo a passo)',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _addStep(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E1A4E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '+ Passo',
                      style: TextStyle(
                          color: Color(0xFF8C52FF), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...(exercise['steps'] as List).asMap().entries.map((stepEntry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E1A4E),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${stepEntry.key + 1}',
                          style: const TextStyle(
                              color: Color(0xFF8C52FF), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        hint: 'Passo ${stepEntry.key + 1}...',
                        initialValue: stepEntry.value,
                        onChanged: (val) => _updateStep(index, stepEntry.key, val),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.play_circle_outline_rounded, color: Color(0xFFE55353), size: 16),
                const SizedBox(width: 8),
                Text(
                  'Vídeo de Execução (YouTube)',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              hint: 'https://youtube.com/watch?v=...',
              initialValue: exercise['videoUrl'],
              onChanged: (val) => exercise['videoUrl'] = val,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddExerciseButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0E13),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(
        painter: DashedRectPainter(color: const Color(0xFF3A2460), strokeWidth: 1.5, gap: 5.0),
        child: InkWell(
          onTap: _addExercise,
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xFF8C52FF), size: 20),
                SizedBox(width: 8),
                Text(
                  'Adicionar Exercício',
                  style: TextStyle(
                    color: Color(0xFF8C52FF),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hint,
      int maxLines = 1,
      String? initialValue,
      void Function(String)? onChanged,
      TextEditingController? controller}) {
    return TextFormField(
      initialValue: controller == null ? initialValue : null,
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: const Color(0xFF16161A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }

  Widget _buildLabeledTextField(
      {required String label,
      required String hint,
      int maxLines = 1,
      IconData? icon,
      String? initialValue,
      void Function(String)? onChanged,
      TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.grey.shade400, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildTextField(
            hint: hint,
            maxLines: maxLines,
            initialValue: initialValue,
            onChanged: onChanged,
            controller: controller),
      ],
    );
  }

  Widget _buildLabeledDropdown(
      {required String label,
      required String value,
      required List<String> items,
      void Function(String?)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: const Color(0xFF1E1433),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF16161A),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({required this.color, required this.strokeWidth, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)));

    Path dashPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
      distance = 0.0;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}