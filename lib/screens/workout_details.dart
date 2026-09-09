import 'package:flutter/material.dart';
import 'package:igym/models/workout_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutDetailsScreen({super.key, required this.workout});

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
                    color: const Color(0xFF1E1433),
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
                  _buildTag(workout.level, _getLevelColor(workout.level)),
                  const SizedBox(width: 8),
                  _buildTag(workout.category, const Color(0xFF8C52FF)),
                ],
              ),
              const SizedBox(height: 16),

              // Título e Descrição
              Text(
                workout.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                workout.description,
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

              // Cards de Exercícios
              ...workout.exercises.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ExerciseExpandableCard(
                      index: entry.key + 1,
                      exercise: entry.value,
                    ),
                  )),
            ],
          ),
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

class ExerciseExpandableCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> exercise;

  const ExerciseExpandableCard({super.key, required this.index, required this.exercise});

  @override
  State<ExerciseExpandableCard> createState() => _ExerciseExpandableCardState();
}

class _ExerciseExpandableCardState extends State<ExerciseExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final steps = exercise['steps'] as List? ?? [];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded ? const Color(0xFF3A2460) : const Color(0xFF28282D),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E1A4E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index}',
                        style: const TextStyle(
                          color: Color(0xFF8C52FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                          exercise['name'] ?? 'Sem nome',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${exercise['sets'] ?? '-'} séries',
                              style: const TextStyle(
                                color: Color(0xFF8C52FF),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text('×', style: TextStyle(color: Colors.grey.shade500)),
                            ),
                            Text(
                              '${exercise['reps'] ?? '-'} reps',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (exercise['muscleGroup'] != null &&
                                exercise['muscleGroup'].toString().isNotEmpty) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF28282D),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  exercise['muscleGroup'],
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (exercise['observations'] != null &&
                      exercise['observations'].toString().isNotEmpty) ...[
                    _buildSectionTitle(Icons.edit_note_rounded, 'DESCRIÇÃO', const Color(0xFF8C52FF)),
                    const SizedBox(height: 8),
                    Text(
                      exercise['observations'],
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (steps.isNotEmpty && steps.any((s) => s.toString().isNotEmpty)) ...[
                    _buildSectionTitle(
                        Icons.format_list_bulleted_rounded, 'COMO EXECUTAR', const Color(0xFF8C52FF)),
                    const SizedBox(height: 12),
                    ...steps.asMap().entries.where((e) => e.value.toString().isNotEmpty).map(
                        (e) => _buildStep(e.key + 1, e.value)),
                    const SizedBox(height: 20),
                  ],
                  if (exercise['videoUrl'] != null &&
                      exercise['videoUrl'].toString().isNotEmpty) ...[
                    _buildSectionTitle(
                        Icons.play_circle_outline_rounded, 'VÍDEO DE EXECUÇÃO', const Color(0xFFE55353)),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(exercise['videoUrl']);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1428),
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
                              child: const Icon(Icons.play_arrow_rounded,
                                  color: Color(0xFFE55353), size: 32),
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
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

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
