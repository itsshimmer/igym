import 'dart:math';
import 'package:flutter/material.dart';
import 'package:igym/providers/auth_provider.dart';
import 'package:igym/providers/workout_provider.dart';
import 'package:igym/screens/about_screen.dart';
import 'package:igym/screens/help_center_screen.dart';
import 'package:igym/screens/prescribe_workout.dart';
import 'package:igym/screens/privacy_screen.dart';
import 'package:igym/screens/profile_screen.dart';
import 'package:igym/screens/role_selector.dart';
import 'package:igym/screens/student_content.dart';
import 'package:igym/screens/teacher_dashboard.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final int _selectedIndex = 2;

  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _remindersEnabled = false;

  void _showRatingDialog(BuildContext context) {
    int selectedStars = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF16161A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Avaliar o iGym',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Gostando da sua experiência no app? Conte-nos o que achou!',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      starIndex <= selectedStars ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: const Color(0xFFFFD54F),
                      size: 32,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        selectedStars = starIndex;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Deixe um comentário (opcional)',
                  hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF0F0E13),
                  border: OutlineInputBorder(
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade400)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8C52FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Muito obrigado por avaliar o iGym! 💜'),
                    backgroundColor: Color(0xFF8C52FF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Enviar Avaliação', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF8C52FF),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.userName ?? 'Usuário';
    final userEmail = auth.user?.email ?? 'Sem e-mail';
    final userRole = auth.userRole ?? 'aluno';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configurações',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Card do Perfil
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16161A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF28282D)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8C52FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
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
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              userEmail,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Badge Role
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E1A4E),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(userRole == 'professor' ? '👩‍🏫' : '🏋️',
                                      style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    userRole.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF8C52FF),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: Colors.grey.shade500),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('CONTA'),
              _buildSettingsGroup(
                children: [
                  _buildSettingsItem(
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFF8C52FF),
                    title: 'Perfil',
                    subtitle: 'Editar informações pessoais',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF65C48C),
                    title: 'Privacidade',
                    subtitle: 'Controle seus dados',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('PREFERÊNCIAS'),
              _buildSettingsGroup(
                children: [
                  _buildSwitchItem(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFFE5A444),
                    title: 'Notificações',
                    subtitle: 'Novos treinos e lembretes',
                    value: _notificationsEnabled,
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                      _showNotificationSnackBar(
                        val ? 'Notificações ativadas' : 'Notificações desativadas',
                      );
                    },
                  ),
                  _buildSwitchItem(
                    icon: Icons.dark_mode_outlined,
                    iconColor: const Color(0xFF5A44E5),
                    title: 'Modo Escuro',
                    subtitle: 'Interface dark sempre ativa',
                    value: _darkModeEnabled,
                    onChanged: (val) {
                      setState(() => _darkModeEnabled = val);
                      _showNotificationSnackBar(
                        val ? 'Modo Escuro ativado' : 'Modo Claro indisponível no tema atual',
                      );
                    },
                  ),
                  _buildSwitchItem(
                    icon: Icons.fitness_center_rounded,
                    iconColor: const Color(0xFFE56291),
                    title: 'Lembretes de Treino',
                    subtitle: 'Lembrete diário para treinar',
                    value: _remindersEnabled,
                    onChanged: (val) {
                      setState(() => _remindersEnabled = val);
                      _showNotificationSnackBar(
                        val ? 'Lembretes diários ativados' : 'Lembretes diários desativados',
                      );
                    },
                    rotateIcon: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('SUPORTE'),
              _buildSettingsGroup(
                children: [
                  _buildSettingsItem(
                    icon: Icons.help_outline_rounded,
                    iconColor: const Color(0xFF4DB6AC),
                    title: 'Central de Ajuda',
                    subtitle: 'FAQ e tutoriais',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.star_border_rounded,
                    iconColor: const Color(0xFFFFD54F),
                    title: 'Avaliar o App',
                    subtitle: 'Deixe sua avaliação na loja',
                    onTap: () => _showRatingDialog(context),
                  ),
                  _buildSettingsItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.grey.shade400,
                    title: 'Sobre o iGym',
                    subtitle: 'Versão 1.0.0',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Botão Sair da Conta
              OutlinedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context, rootNavigator: true);
                  context.read<WorkoutProvider>().clearWorkouts();
                  await auth.logout();
                  if (mounted) {
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const RoleSelectorScreen()),
                      (route) => false,
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Color(0xFF3A1A22)),
                  backgroundColor: const Color(0xFF1A1115),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Color(0xFFE55353), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sair da Conta',
                      style: TextStyle(
                        color: Color(0xFFE55353),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  'iGym v1.0.0 · Desenvolvido com 💜',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, userRole),
    );
  }

  Widget _buildBottomNav(BuildContext context, String userRole) {
    final bool isTeacher = userRole == 'professor';

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
                pageBuilder: (context, a1, a2) =>
                    isTeacher ? const TeacherDashboardScreen() : const StudentContentScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 1) {
            if (isTeacher) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const PrescribeWorkoutScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else {
              // Estudantes podem ter uma aba diferente no índice 1 (como "Treinos")
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const StudentContentScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF8C52FF)),
            label: 'Início',
          ),
          NavigationDestination(
            icon: isTeacher
                ? const Icon(Icons.add_rounded, color: Colors.grey)
                : Transform.rotate(
                    angle: -pi / 4,
                    child: const Icon(Icons.fitness_center_rounded, color: Colors.grey),
                  ),
            selectedIcon: isTeacher
                ? const Icon(Icons.add_rounded, color: Color(0xFF8C52FF))
                : Transform.rotate(
                    angle: -pi / 4,
                    child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF8C52FF)),
                  ),
            label: isTeacher ? 'Prescrever' : 'Treinos',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.settings_rounded, color: Color(0xFF8C52FF)),
            label: 'Config',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({required List<Widget> children}) {
    List<Widget> separatedChildren = [];
    for (int i = 0; i < children.length; i++) {
      separatedChildren.add(children[i]);
      if (i < children.length - 1) {
        separatedChildren.add(
          Divider(color: Colors.grey.shade800, height: 1, indent: 56),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF28282D)),
      ),
      child: Column(
        children: separatedChildren,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool rotateIcon = false,
  }) {
    Widget iconWidget = Icon(icon, color: iconColor, size: 24);
    if (rotateIcon) {
      iconWidget = Transform.rotate(angle: -pi / 4, child: iconWidget);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF8C52FF),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: const Color(0xFF28282D),
          ),
        ],
      ),
    );
  }
}
