import 'dart:math';
import 'package:flutter/material.dart';
import 'package:igym/screens/prescribe_workout.dart';
import 'package:igym/screens/settings.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _selectedIndex = 0; // "Início" é a aba selecionada por padrão

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      const Text(
                        'Aaa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Avatar do Professor
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8C52FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
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
                      value: '48',
                      label: 'Alunos Ativos',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.fitness_center_rounded,
                      iconColor: const Color(0xFFE56291),
                      value: '3',
                      label: 'Treinos',
                      rotateIcon: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.trending_up_rounded,
                      iconColor: const Color(0xFF65C48C),
                      value: '+12',
                      label: 'Esse Mês',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botão: Prescrever Novo Treino
              ElevatedButton(
                onPressed: () {
                  // Navega para a tela de Prescrever Treino
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
                  minimumSize: const Size(double.infinity, 56), // Largura total
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

              // Seção: Treinos Recentes
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
                    onTap: () {
                      // TODO: Navegar para todos os treinos
                    },
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

              // Lista de Treinos Recentes
              _buildWorkoutMiniCard(
                title: 'Treino A – Peito & Tríceps',
                level: 'Intermediário',
                levelColor: const Color(0xFFE5A444), // Laranja
                category: 'Musculação',
                categoryColor: const Color(0xFF8C52FF),
                duration: '60 min',
                exercisesCount: '3 exercícios',
              ),
              const SizedBox(height: 12),
              _buildWorkoutMiniCard(
                title: 'Treino B – Costas & Bíceps',
                level: 'Intermediário',
                levelColor: const Color(0xFFE5A444),
                category: 'Musculação',
                categoryColor: const Color(0xFF8C52FF),
                duration: '65 min',
                exercisesCount: '2 exercícios',
              ),
              const SizedBox(height: 12),
              _buildWorkoutMiniCard(
                title: 'Treino C – Pernas',
                level: 'Avançado',
                levelColor: const Color(0xFFE55353), // Vermelho
                category: 'Musculação',
                categoryColor: const Color(0xFF8C52FF),
                duration: '75 min',
                exercisesCount: '1 exercícios',
              ),
              const SizedBox(height: 32),

              // Seção: Alunos Recentes
              const Text(
                'Alunos Recentes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Lista horizontal de alunos
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStudentAvatar('L', 'Lucas', const Color(0xFF5A44E5)),
                    const SizedBox(width: 16),
                    _buildStudentAvatar('F', 'Fernanda', const Color(0xFFE544A4)),
                    const SizedBox(width: 16),
                    _buildStudentAvatar('R', 'Rafael', const Color(0xFFE57A44)),
                    const SizedBox(width: 16),
                    _buildStudentAvatar('C', 'Camila', const Color(0xFFBBE544)),
                    const SizedBox(width: 16),
                    _buildStudentAvatar('B', 'Bruno', const Color(0xFF44E56B)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      // Barra de navegação inferior do Professor
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF16161A),
          indicatorColor: const Color(0xFF2E1A4E), // Pílula de seleção roxa escuro
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: Color(0xFF8C52FF), fontSize: 12, fontWeight: FontWeight.w600);
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
              // Navega para Configurações sem animação
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
      ),
    );
  }

  /// Widget auxiliar para criar os cards de estatísticas no topo
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

  /// Widget auxiliar para os Treinos Recentes (mini cards horizontais)
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

  /// Widget auxiliar para gerar as Tags dentro dos cards
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
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

  /// Widget auxiliar para os avatares dos "Alunos Recentes"
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