import 'dart:math';
import 'package:flutter/material.dart';
import 'package:igym/providers/auth_provider.dart';
import 'package:igym/providers/workout_provider.dart';
import 'package:igym/screens/prescribe_workout.dart';
import 'package:igym/screens/settings.dart';
import 'package:provider/provider.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _students = [];
  bool _isLoadingStudents = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<WorkoutProvider>().fetchWorkoutsForTeacher(auth.user!.uid);
        final students = await auth.fetchStudentsForTeacher(auth.user!.uid);
        if (mounted) {
          setState(() {
            _students = students;
            _isLoadingStudents = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final workoutProvider = context.watch<WorkoutProvider>();
    final userName = auth.userName ?? 'Professor';
    final workouts = workoutProvider.teacherWorkouts;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (auth.user != null) {
              await workoutProvider.fetchWorkoutsForTeacher(auth.user!.uid);
              final students = await auth.fetchStudentsForTeacher(auth.user!.uid);
              if (mounted) {
                setState(() {
                  _students = students;
                });
              }
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Saudação e Avatar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, Professor 👋',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C52FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          userName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Cards de Estatísticas
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.people_outline_rounded,
                        iconColor: const Color(0xFF8C52FF),
                        value: _students.length.toString(),
                        label: 'Alunos Ativos',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.fitness_center_rounded,
                        iconColor: const Color(0xFFE56291),
                        value: workouts.length.toString(),
                        label: 'Treinos',
                        rotateIcon: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.trending_up_rounded,
                        iconColor: const Color(0xFF65C48C),
                        value: '+0',
                        label: 'Esse Mês',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrescribeWorkoutScreen(),
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
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Prescrever Novo Treino',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Treinos Recentes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Ver todos',
                        style: TextStyle(
                          color: Color(0xFF8C52FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (workoutProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (workouts.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        'Nenhum treino prescrito ainda.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...workouts.take(5).map((workout) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildWorkoutMiniCard(
                          title: workout.title,
                          level: workout.level,
                          levelColor: _getLevelColor(workout.level),
                          category: workout.category,
                          categoryColor: const Color(0xFF8C52FF),
                          duration: workout.duration,
                          exercisesCount: '${workout.exercises.length} exercícios',
                        ),
                      )),

                const SizedBox(height: 32),

                const Text(
                  'Meus Alunos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                if (_isLoadingStudents)
                  const Center(child: CircularProgressIndicator())
                else if (_students.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Nenhum aluno vinculado.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _students.map((student) {
                        final name = student['nome'] ?? 'Aluno';
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrescribeWorkoutScreen(
                                    studentId: student['id'],
                                  ),
                                ),
                              );
                            },
                            child: _buildStudentAvatar(
                              name[0].toUpperCase(),
                              name.split(' ')[0],
                              const Color(0xFF5A44E5),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, a1, a2) => const PrescribeWorkoutScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 2) {
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

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    bool rotateIcon = false,
  }) {
    Widget iconWidget = Icon(icon, color: iconColor, size: 20);
    if (rotateIcon) {
      iconWidget = Transform.rotate(angle: -pi / 4, child: iconWidget);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF28282D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconWidget,
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutMiniCard({
    required String title,
    required String level,
    required Color levelColor,
    required String category,
    required Color categoryColor,
    required String duration,
    required String exercisesCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF28282D)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildTag(level, levelColor),
                    const SizedBox(width: 8),
                    _buildTag(category, categoryColor),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, color: Colors.grey.shade500, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      duration,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.bar_chart_rounded, color: Colors.grey.shade500, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      exercisesCount,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade600),
        ],
      ),
    );
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
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStudentAvatar(String initial, String name, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}