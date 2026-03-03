import 'package:flutter/material.dart';
import 'package:igym/screens/student_content.dart';

class SelectTeacherScreen extends StatelessWidget {
  const SelectTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista simulando os dados vindos de uma API ou banco de dados
    final List<Map<String, dynamic>> teachers = [
      {
        'name': 'Carlos Silva',
        'initials': 'CS',
        'color': const Color(0xFF8C52FF), // Roxo
        'specialty': 'Musculação & Hipertrofia',
        'rating': '4.9',
        'students': '48',
      },
      {
        'name': 'Ana Rodrigues',
        'initials': 'AR',
        'color': const Color(0xFFE56291), // Rosa
        'specialty': 'Funcional & CrossFit',
        'rating': '4.8',
        'students': '35',
      },
      {
        'name': 'Pedro Santos',
        'initials': 'PS',
        'color': const Color(0xFF65C48C), // Verde
        'specialty': 'Emagrecimento & Cardio',
        'rating': '4.7',
        'students': '62',
      },
      {
        'name': 'Juliana Costa',
        'initials': 'JC',
        'color': const Color(0xFFE5A444), // Laranja
        'specialty': 'Yoga & Flexibilidade',
        'rating': '5',
        'students': '29',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Header
              Text(
                'BEM-VINDO AO IGYM',
                style: TextStyle(
                  color: const Color(0xFF8C52FF),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Escolha seu Professor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione quem vai prescrever seus treinos',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),

              // Barra de Busca
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar professor ou especialidade...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  filled: true,
                  fillColor: const Color(0xFF16161A),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
              const SizedBox(height: 24),

              // Contador de professores disponíveis
              Text(
                '${teachers.length} professores disponíveis',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),

              // Lista de Professores
              Expanded(
                child: ListView.separated(
                  itemCount: teachers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];
                    return TeacherCard(
                      name: teacher['name'],
                      initials: teacher['initials'],
                      avatarColor: teacher['color'],
                      specialty: teacher['specialty'],
                      rating: teacher['rating'],
                      students: teacher['students'],
                      onTap: () {
                        // TODO: Navegar para os detalhes do professor selecionado

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudentContentScreen(),
                            ),
                          );

                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget customizado para o Card do Professor
class TeacherCard extends StatelessWidget {
  final String name;
  final String initials;
  final Color avatarColor;
  final String specialty;
  final String rating;
  final String students;
  final VoidCallback onTap;

  const TeacherCard({
    super.key,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.specialty,
    required this.rating,
    required this.students,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF28282D)),
        ),
        child: Row(
          children: [
            // Avatar (Iniciais)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: avatarColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Informações do Professor
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
                    specialty,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Linha de Avaliação e Alunos
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.people_outline, color: Colors.grey.shade500, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$students alunos',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Ícone de seta (Chevron)
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}