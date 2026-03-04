import 'dart:math';
import 'package:flutter/material.dart';
import 'teacher_dashboard.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final int _selectedIndex = 2; // "Config" selecionado

  // Estados dos Switches
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _remindersEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16161A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF28282D)),
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C52FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Informações do Usuário
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aaa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'aaa',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Badge Professor
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E1A4E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('👩‍🏫', style: TextStyle(fontSize: 12)),
                                SizedBox(width: 4),
                                Text(
                                  'Professor',
                                  style: TextStyle(
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

                    // Seta
                    Icon(Icons.chevron_right_rounded, color: Colors.grey.shade500),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Seção: CONTA
              _buildSectionHeader('CONTA'),
              _buildSettingsGroup(
                children: [
                  _buildSettingsItem(
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFF8C52FF),
                    title: 'Perfil',
                    subtitle: 'Editar informações pessoais',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF65C48C),
                    title: 'Privacidade',
                    subtitle: 'Controle seus dados',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Seção: PREFERÊNCIAS
              _buildSectionHeader('PREFERÊNCIAS'),
              _buildSettingsGroup(
                children: [
                  _buildSwitchItem(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFFE5A444), // Laranja/Amarelo
                    title: 'Notificações',
                    subtitle: 'Novos treinos e lembretes',
                    value: _notificationsEnabled,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  _buildSwitchItem(
                    icon: Icons.dark_mode_outlined,
                    iconColor: const Color(0xFF5A44E5), // Azul arroxeado
                    title: 'Modo Escuro',
                    subtitle: 'Interface dark sempre ativa',
                    value: _darkModeEnabled,
                    onChanged: (val) => setState(() => _darkModeEnabled = val),
                  ),
                  _buildSwitchItem(
                    icon: Icons.fitness_center_rounded,
                    iconColor: const Color(0xFFE56291), // Rosa
                    title: 'Lembretes de Treino',
                    subtitle: 'Lembrete diário para treinar',
                    value: _remindersEnabled,
                    onChanged: (val) => setState(() => _remindersEnabled = val),
                    rotateIcon: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Seção: SUPORTE
              _buildSectionHeader('SUPORTE'),
              _buildSettingsGroup(
                children: [
                  _buildSettingsItem(
                    icon: Icons.help_outline_rounded,
                    iconColor: const Color(0xFF4DB6AC), // Verde água
                    title: 'Central de Ajuda',
                    subtitle: 'FAQ e tutoriais',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.star_border_rounded,
                    iconColor: const Color(0xFFFFD54F), // Amarelo
                    title: 'Avaliar o App',
                    subtitle: 'Deixe sua avaliação na loja',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.grey.shade400,
                    title: 'Sobre o iGym',
                    subtitle: 'Versão 1.0.0',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Botão Sair da Conta
              OutlinedButton(
                onPressed: () {
                  // TODO: Lógica de logout e voltar para seleção de papel
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Color(0xFF3A1A22)), // Borda avermelhada escura
                  backgroundColor: const Color(0xFF1A1115), // Fundo avermelhado muito escuro
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

              // Footer Credit
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
      // Barra de navegação inferior
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF16161A),
          indicatorColor: const Color(0xFF2E1A4E),
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
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const TeacherDashboardScreen(),
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

  /// Helper: Cabeçalho das Seções (ex: CONTA, PREFERÊNCIAS)
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

  /// Helper: Agrupa os itens em um container com bordas e divisórias
  Widget _buildSettingsGroup({required List<Widget> children}) {
    List<Widget> separatedChildren = [];
    for (int i = 0; i < children.length; i++) {
      separatedChildren.add(children[i]);
      if (i < children.length - 1) {
        separatedChildren.add(
          Divider(color: Colors.grey.shade800, height: 1, indent: 56), // Recuo para alinhar com o texto
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

  /// Helper: Item de configuração padrão (com Seta de navegação)
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

  /// Helper: Item de configuração com Switch (Liga/Desliga)
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