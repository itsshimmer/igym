import 'dart:math';
import 'package:flutter/material.dart';
import 'package:igym/models/workout_model.dart';
import 'package:igym/providers/auth_provider.dart';
import 'package:igym/providers/workout_provider.dart';
import 'package:igym/screens/select_teacher.dart';
import 'package:igym/screens/settings.dart';
import 'package:igym/screens/workout_details.dart';
import 'package:provider/provider.dart';

class StudentContentScreen extends StatefulWidget {
  const StudentContentScreen({super.key});

  @override
  State<StudentContentScreen> createState() => _StudentContentScreenState();
}

class _StudentContentScreenState extends State<StudentContentScreen> {
  int _selectedIndex = 1;
  Map<String, dynamic>? _teacherData;
  bool _isLoadingTeacher = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<WorkoutProvider>().fetchWorkoutsForStudent(auth.user!.uid);
        if (auth.teacherId != null) {
          final teacher = await auth.fetchUserDataById(auth.teacherId!);
          if (mounted) {
            setState(() {
              _teacherData = teacher;
              _isLoadingTeacher = false;
            });
          }
        } else {
          if (mounted) {
            setState(() => _isLoadingTeacher = false);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final workoutProvider = context.watch<WorkoutProvider>();
    final userName = auth.userName ?? 'Aluno';
    final workouts = workoutProvider.studentWorkouts;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (auth.user != null) {
              await workoutProvider.fetchWorkoutsForStudent(auth.user!.uid);
              if (auth.teacherId != null) {
                final teacher = await auth.fetchUserDataById(auth.teacherId!);
                if (mounted) {
                  setState(() => _teacherData = teacher);
                }
              }
            }
          },
          child: _buildTreinosTab(userName, workoutProvider, workouts),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
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
            if (index == 2) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const SettingsScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF8C52FF)),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Transform.rotate(
                angle: -pi / 4,
                child: const Icon(Icons.fitness_center_rounded, color: Colors.grey),
              ),
              selectedIcon: Transform.rotate(
                angle: -pi / 4,
                child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF8C52FF)),
              ),
              label: 'Treinos',
            ),
            const NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.settings_rounded, color: Color(0xFF8C52FF)),
              label: 'Config',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreinosTab(
      String userName, WorkoutProvider workoutProvider, List<WorkoutModel> workouts) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, $userName 👋',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Meus Treinos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF28282D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Card do Professor Atual
          if (_isLoadingTeacher)
            const Center(child: CircularProgressIndicator())
          else if (_teacherData == null)
            _buildNoTeacherCard()
          else
            _buildTeacherCard(_teacherData!),

          const SizedBox(height: 24),

          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar treino...',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
              suffixIcon: Icon(Icons.filter_alt_outlined, color: Colors.grey.shade500),
              filled: true,
              fillColor: const Color(0xFF16161A),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
          const SizedBox(height: 20),

          Row(
            children: [
              _buildFilterChip('Todos', isSelected: true),
              const SizedBox(width: 12),
              _buildFilterChip('Funcional', isSelected: false),
            ],
          ),
          const SizedBox(height: 24),

          if (workoutProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (workouts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'Nenhum treino encontrado.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...workouts.map((workout) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildWorkoutCard(context, workout),
                )),
        ],
      ),
    );
  }

  Widget _buildNoTeacherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE55353).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFE55353)),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Você ainda não selecionou um professor.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectTeacherScreen()),
              );
            },
            child: const Text('Selecionar', style: TextStyle(color: Color(0xFF8C52FF))),
          )
        ],
      ),
    );
  }

  Widget _buildTeacherCard(Map<String, dynamic> teacher) {
    final name = teacher['nome'] ?? 'Professor';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF18102B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A2460)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE56291),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  teacher['especialidade'] ?? 'Instrutor',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectTeacherScreen()),
              );
            },
            child: const Text(
              'Trocar',
              style: TextStyle(
                color: Color(0xFF8C52FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8C52FF) : const Color(0xFF28282D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade300,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, WorkoutModel workout) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailsScreen(workout: workout),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF28282D)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTag(workout.level, _getLevelColor(workout.level)),
                const SizedBox(width: 8),
                _buildTag(workout.category, const Color(0xFF8C52FF)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        workout.description,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E1A4E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF8C52FF),
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade800, height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: Colors.grey.shade500, size: 16),
                const SizedBox(width: 6),
                Text(
                  workout.duration,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
                const SizedBox(width: 20),
                Icon(Icons.bar_chart_rounded, color: Colors.grey.shade500, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${workout.exercises.length} exercícios',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'iniciante':
        return const Color(0xFF65C48C);
      case 'intermediário':
        return const Color(0xFFE5A444);
      case 'avançado':
        return const Color(0xFFE55353);
      default:
        return const Color(0xFF8C52FF);
    }
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}