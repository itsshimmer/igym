import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:igym/screens/teacher_dashboard.dart';

class PrescribeWorkoutScreen extends StatefulWidget {
  const PrescribeWorkoutScreen({super.key});

  @override
  State<PrescribeWorkoutScreen> createState() => _PrescribeWorkoutScreenState();
}

class _PrescribeWorkoutScreenState extends State<PrescribeWorkoutScreen> {
  final int _selectedIndex = 1; // "Prescrever" selecionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: Column(
          children: [
            // Área Rolável (Formulário)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildWorkoutInfoSection(),
                    const SizedBox(height: 32),
                    const Text(
                      'Exercícios (1)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExerciseCard(),
                    const SizedBox(height: 16),
                    _buildAddExerciseButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Botão Fixo na parte inferior (Desativado)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0E13),
                border: Border(top: BorderSide(color: Colors.grey.shade900)),
              ),
              child: ElevatedButton(
                onPressed: null, // Desativado até que o título seja preenchido
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16161A), // Fundo desativado
                  disabledBackgroundColor: const Color(0xFF16161A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Informe o título do treino',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600, // Texto desativado
                  ),
                ),
              ),
            ),
          ],
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
              // Se clicar em "Início" (índice 0), volta para o Dashboard sem animação
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const TeacherDashboardScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else if (index == 2) {
              // TODO: Futura navegação para a tela de Configurações
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

  /// Cabeçalho com botão de voltar
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

  /// Seção de Informações do Treino
  Widget _buildWorkoutInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.description_outlined, color: Color(0xFF8C52FF), size: 20),
            const SizedBox(width: 8),
            const Text(
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
        ),
        const SizedBox(height: 16),
        _buildLabeledTextField(
          label: 'Descrição',
          hint: 'Descreva o objetivo e orientações gerais do treino...',
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildLabeledDropdown(
                label: 'Categoria',
                value: 'Musculação',
                items: ['Musculação', 'Funcional', 'Cardio'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLabeledDropdown(
                label: 'Nível',
                value: 'Intermediário',
                items: ['Iniciante', 'Intermediário', 'Avançado'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildLabeledDropdown(
          label: 'Duração',
          value: '60 min',
          items: ['30 min', '45 min', '60 min', '90 min'],
        ),
      ],
    );
  }

  /// Card de Criação de Exercício
  Widget _buildExerciseCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A2460), width: 1.5), // Borda ativa
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do Card
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EXERCÍCIO 1',
                      style: TextStyle(
                        color: Color(0xFF8C52FF),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sem nome',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Botão Lixeira
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE55353).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE55353), size: 20),
              ),
              const SizedBox(width: 8),
              // Botão Recolher
              const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),

          // Campos do Exercício
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildLabeledTextField(label: 'Nome do Exercício *', hint: 'Ex: Supino Reto'),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildLabeledTextField(label: 'Grupo Muscular', hint: 'Peito'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLabeledTextField(label: 'Séries', hint: '3'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLabeledTextField(label: 'Repetições', hint: '12'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabeledTextField(
            label: 'Descrição / Observações',
            hint: 'Dicas, cuidados, variações, carga sugerida...',
            maxLines: 3,
            icon: Icons.edit_note_rounded,
          ),
          const SizedBox(height: 24),

          // Passo a Passo
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E1A4E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '+ Passo',
                  style: TextStyle(color: Color(0xFF8C52FF), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
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
                child: const Center(
                  child: Text(
                    '1',
                    style: TextStyle(color: Color(0xFF8C52FF), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField(hint: 'Passo 1...')),
            ],
          ),
          const SizedBox(height: 20),

          // Vídeo do YouTube
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
          _buildTextField(hint: 'https://youtube.com/watch?v=...'),
        ],
      ),
    );
  }

  /// Botão Adicionar Exercício (Simulando Borda Tracejada)
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
          onTap: () {
            // TODO: Lógica para adicionar novo exercício à lista
          },
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

  /// Helper: Campo de Texto Simples
  Widget _buildTextField({required String hint, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: const Color(0xFF16161A), // Fundo do input
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

  /// Helper: Label + Campo de Texto
  Widget _buildLabeledTextField({required String label, required String hint, int maxLines = 1, IconData? icon}) {
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
        _buildTextField(hint: hint, maxLines: maxLines),
      ],
    );
  }

  /// Helper: Label + Dropdown
  Widget _buildLabeledDropdown({required String label, required String value, required List<String> items}) {
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
          initialValue: value,
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
          onChanged: (newValue) {},
        ),
      ],
    );
  }
}

/// Custom Painter para criar a borda tracejada do botão "Adicionar Exercício"
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
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)));

    Path dashPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2; // Tamanho do traço + tamanho do espaço
      }
      distance = 0.0;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}