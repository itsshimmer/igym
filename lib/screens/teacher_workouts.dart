import 'package:flutter/material.dart';
import 'package:igym/models/workout_model.dart';
import 'package:igym/providers/auth_provider.dart';
import 'package:igym/providers/workout_provider.dart';
import 'package:igym/screens/prescribe_workout.dart';
import 'package:igym/screens/workout_details.dart';
import 'package:provider/provider.dart';

class TeacherWorkoutsScreen extends StatefulWidget {
  const TeacherWorkoutsScreen({super.key});

  @override
  State<TeacherWorkoutsScreen> createState() => _TeacherWorkoutsScreenState();
}

class _TeacherWorkoutsScreenState extends State<TeacherWorkoutsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  final List<String> _categories = ['Todos', 'Musculação', 'Funcional', 'Cardio'];

  void _confirmDeleteWorkout(WorkoutModel workout) {
    final messenger = ScaffoldMessenger.of(context);
    final auth = context.read<AuthProvider>();
    final workoutProvider = context.read<WorkoutProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF16161A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFE55353)),
            SizedBox(width: 10),
            Text('Excluir Treino', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Text(
          'Deseja realmente excluir o treino "${workout.title}"? Esta ação não poderá ser desfeita.',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade400)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE55353),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final uid = auth.user?.uid;
              Navigator.pop(dialogContext);

              if (uid != null) {
                final success = await workoutProvider.deleteWorkout(workout.id, uid);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Treino excluído com sucesso!' : 'Erro ao excluir treino.'),
                    backgroundColor: const Color(0xFFE55353),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    final workouts = workoutProvider.teacherWorkouts;

    final filteredWorkouts = workouts.where((w) {
      final matchesSearch = w.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Todos' || w.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0E13),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Meus Treinos Prescritos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                children: [
                  // Campo de busca
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Buscar treino por nome...',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade500),
                      filled: true,
                      fillColor: const Color(0xFF16161A),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF28282D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF28282D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF8C52FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filtros de Categoria
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedCategory = cat);
                              }
                            },
                            backgroundColor: const Color(0xFF16161A),
                            selectedColor: const Color(0xFF8C52FF),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade400,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF8C52FF) : const Color(0xFF28282D),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Lista de treinos
            Expanded(
              child: workoutProvider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF8C52FF)))
                  : filteredWorkouts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fitness_center_rounded,
                                  color: Colors.grey.shade700, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum treino encontrado',
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                          itemCount: filteredWorkouts.length,
                          itemBuilder: (context, index) {
                            final workout = filteredWorkouts[index];
                            return _buildWorkoutCard(context, workout);
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8C52FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Novo Treino', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrescribeWorkoutScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, WorkoutModel workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF28282D)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDetailsScreen(workout: workout),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildTag(workout.level, _getLevelColor(workout.level)),
                      const SizedBox(width: 8),
                      _buildTag(workout.category, const Color(0xFF8C52FF)),
                    ],
                  ),

                  // Menu Ações (Editar / Deletar)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade400),
                    color: const Color(0xFF1E1433),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrescribeWorkoutScreen(
                              workoutToEdit: workout,
                              studentId: workout.studentId,
                            ),
                          ),
                        );
                      } else if (value == 'delete') {
                        _confirmDeleteWorkout(workout);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, color: Color(0xFF8C52FF), size: 18),
                            SizedBox(width: 10),
                            Text('Editar Treino', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, color: Color(0xFFE55353), size: 18),
                            SizedBox(width: 10),
                            Text('Excluir Treino', style: TextStyle(color: Color(0xFFE55353), fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                workout.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (workout.description.isNotEmpty) ...[
                const SizedBox(height: 6),
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
              const SizedBox(height: 16),

              Divider(color: Colors.grey.shade800, height: 1),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, color: Color(0xFF8C52FF), size: 20),
                        tooltip: 'Editar',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrescribeWorkoutScreen(
                                workoutToEdit: workout,
                                studentId: workout.studentId,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Color(0xFFE55353), size: 20),
                        tooltip: 'Excluir',
                        onPressed: () => _confirmDeleteWorkout(workout),
                      ),
                    ],
                  ),
                ],
              ),
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
