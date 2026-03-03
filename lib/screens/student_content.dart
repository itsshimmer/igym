import 'dart:math';
import 'package:flutter/material.dart';
import 'package:igym/screens/settings.dart';
import 'package:igym/screens/workout_details.dart';

class StudentContentScreen extends StatefulWidget {
  const StudentContentScreen({super.key});

  @override
  State<StudentContentScreen> createState() => _StudentContentScreenState();
}

class _StudentContentScreenState extends State<StudentContentScreen> {
  // Começamos no índice 1 ("Treinos") para refletir a imagem
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      // Corpo da tela (renderiza o conteúdo da aba selecionada)
      body: SafeArea(
        child: _buildTreinosTab(),
      ),
      // Barra de navegação inferior estilo Material 3
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF16161A),
          indicatorColor: const Color(0xFF2E1A4E), // Fundo roxo escuro (pílula)
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
            if (index == 2) {
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

  /// O conteúdo principal da aba de Treinos
  Widget _buildTreinosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                    'Olá, Aaa 👋',
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
              // Avatar do Aluno
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF28282D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF18102B), // Leve tom roxo escuro no fundo
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF3A2460)), // Borda roxa
            ),
            child: Row(
              children: [
                // Avatar do Professor
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE56291), // Rosa
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'AR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ana Rodrigues',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Funcional & CrossFit',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botão "Trocar"
                TextButton(
                  onPressed: () {
                    // TODO: Ação para voltar e trocar de professor
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
          ),
          const SizedBox(height: 24),

          // Barra de Busca
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

          // Chips de Filtro
          Row(
            children: [
              _buildFilterChip('Todos', isSelected: true),
              const SizedBox(width: 12),
              _buildFilterChip('Funcional', isSelected: false),
            ],
          ),
          const SizedBox(height: 24),

          // Lista de Treinos (neste caso, o Card de Exemplo)
          _buildWorkoutCard(context),
        ],
      ),
    );
  }

  /// Widget auxiliar para criar os Chips de Filtro ("Todos", "Funcional")
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

  /// Widget do Card de Treino
  /// Widget do Card de Treino
  Widget _buildWorkoutCard(BuildContext context) { // <-- Adicionei o context aqui
    return GestureDetector(
      onTap: () {
        // Navega para a tela de detalhes do treino
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WorkoutDetailsScreen(),
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
            // Tags
            Row(
              children: [
                _buildTag('Iniciante', const Color(0xFF65C48C)),
                const SizedBox(width: 8),
                _buildTag('Funcional', const Color(0xFF8C52FF)),
              ],
            ),
            const SizedBox(height: 16),

            // Título e Botão de Ação
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'HIIT Funcional – Full Body',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Treino de alta intensidade com intervalos para queima de gordura e condicionamento físico.',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Botão com Seta Roxa
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E1A4E), // Roxo escuro
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF8C52FF), // Roxo claro
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade800, height: 1),
            const SizedBox(height: 16),

            // Rodapé do Card (Duração, Exercícios, Data)
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: Colors.grey.shade500, size: 16),
                const SizedBox(width: 6),
                Text(
                  '45 min',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
                const SizedBox(width: 20),
                Icon(Icons.bar_chart_rounded, color: Colors.grey.shade500, size: 16),
                const SizedBox(width: 6),
                Text(
                  '1 exercícios',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  '2026-02-27',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar para gerar as Tags (Iniciante, Funcional) com fundo transparente
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
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}