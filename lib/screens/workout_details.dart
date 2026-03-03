import 'package:flutter/material.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  const WorkoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botão Voltar (Customizado)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1433), // Fundo roxo escuro
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Voltar',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tags
              Row(
                children: [
                  _buildTag('Iniciante', const Color(0xFF65C48C)),
                  const SizedBox(width: 8),
                  _buildTag('Funcional', const Color(0xFF8C52FF)),
                ],
              ),
              const SizedBox(height: 16),

              // Título e Descrição
              const Text(
                'HIIT Funcional – Full Body',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Treino de alta intensidade com intervalos para queima de gordura e condicionamento físico.',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Info Row (Duração, Exercícios, Autor)
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
                  const Text(
                    'Por Ana Rodrigues',
                    style: TextStyle(
                      color: Color(0xFF8C52FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Seção de Exercícios
              const Text(
                'Exercícios',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Card de Exercício Expansível
              const ExerciseExpandableCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget auxiliar para gerar as Tags
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

/// Widget Stateful para o Card do Exercício (gerencia abrir/fechar)
class ExerciseExpandableCard extends StatefulWidget {
  const ExerciseExpandableCard({super.key});

  @override
  State<ExerciseExpandableCard> createState() => _ExerciseExpandableCardState();
}

class _ExerciseExpandableCardState extends State<ExerciseExpandableCard> {
  bool _isExpanded = true; // Começa aberto para refletir o design

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16161A), // Fundo do card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded ? const Color(0xFF3A2460) : const Color(0xFF28282D),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do Card (Sempre visível)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Número do Exercício
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E1A4E), // Fundo roxo escuro
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Color(0xFF8C52FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Informações
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Burpee',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              '4 séries',
                              style: TextStyle(
                                color: Color(0xFF8C52FF),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text('×', style: TextStyle(color: Colors.grey.shade500)),
                            ),
                            const Text(
                              '10 reps',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Badge Full Body
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF28282D),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Full Body',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Ícone de Expandir/Recolher
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),

          // Corpo do Card (Visível apenas se expandido)
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Seção: Descrição
                  _buildSectionTitle(Icons.edit_note_rounded, 'DESCRIÇÃO', const Color(0xFF8C52FF)),
                  const SizedBox(height: 8),
                  Text(
                    'Exercício completo que trabalha o corpo todo. Ótimo para condicionamento cardiovascular.',
                    style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Seção: Como Executar
                  _buildSectionTitle(Icons.format_list_bulleted_rounded, 'COMO EXECUTAR', const Color(0xFF8C52FF)),
                  const SizedBox(height: 12),
                  _buildStep(1, 'Fique em pé com pés na largura dos ombros'),
                  _buildStep(2, 'Abaixe e coloque as mãos no chão'),
                  _buildStep(3, 'Jogue os pés para trás para posição de prancha'),
                  _buildStep(4, 'Faça uma flexão (opcional para iniciantes)'),
                  _buildStep(5, 'Volte os pés para as mãos e salte verticalmente com os braços para cima'),
                  const SizedBox(height: 20),

                  // Seção: Vídeo de Execução
                  _buildSectionTitle(Icons.play_circle_outline_rounded, 'VÍDEO DE EXECUÇÃO', const Color(0xFFE55353)), // Cor avermelhada do design
                  const SizedBox(height: 12),

                  // Placeholder do Vídeo
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1428), // Fundo levemente avermelhado escuro
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF332036)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE55353), width: 2),
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Color(0xFFE55353), size: 32),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Assistir vídeo no YouTube',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Título de cada sub-seção (ex: DESCRIÇÃO, COMO EXECUTAR)
  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  /// Item da lista de passos
  Widget _buildStep(int stepNumber, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF2E1A4E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Color(0xFF8C52FF),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}