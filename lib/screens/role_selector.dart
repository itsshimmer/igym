import 'dart:math';
import 'package:flutter/material.dart';

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E13), // Fundo escuro da tela
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF8C52FF), // Roxo do logo
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -pi / 4, // Rotacionando o halter em 45 graus
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Título iGym
              const Text(
                'iGym',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Subtítulo
              Text(
                'Sua academia na palma da mão',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFBDBDBD), // Equivalente a Colors.grey.shade400
                ),
              ),

              const SizedBox(height: 60),

              // Pergunta
              const Text(
                'Como você quer continuar?',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFBDBDBD),
                ),
              ),
              const SizedBox(height: 24),

              // Card: Sou Professor
              RoleCard(
                title: 'Sou Professor',
                subtitle: 'Prescreva treinos para seus alunos',
                icon: Icons.school_outlined,
                iconBgColor: const Color(0xFF8C52FF),
                iconColor: Colors.white,
                cardBgColor: const Color(0xFF1E1433),
                borderColor: const Color(0xFF3A2460),
                chevronColor: const Color(0xFF8C52FF),
                onTap: () {
                  // TODO: Navegar para a rota do Professor
                },
              ),
              const SizedBox(height: 16),

              // Card: Sou Aluno
              RoleCard(
                title: 'Sou Aluno',
                subtitle: 'Acesse seus treinos prescritos',
                icon: Icons.fitness_center_rounded,
                iconBgColor: const Color(0xFF28282D),
                iconColor: const Color(0xFFBDBDBD),
                cardBgColor: const Color(0xFF16161A),
                borderColor: const Color(0xFF28282D),
                chevronColor: const Color(0xFF9E9E9E),
                isIconRotated: true,
                onTap: () {
                  // TODO: Navegar para a rota do Aluno
                },
              ),

              const Spacer(),

              // Footer
              const Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'iGym © 2026 · Todos os direitos reservados',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF616161),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget customizado para os botões de seleção de perfil
class RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color cardBgColor;
  final Color borderColor;
  final Color chevronColor;
  final bool isIconRotated;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.cardBgColor,
    required this.borderColor,
    required this.chevronColor,
    this.isIconRotated = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(icon, color: iconColor, size: 28);

    // Rotaciona o ícone se for o halter
    if (isIconRotated) {
      iconWidget = Transform.rotate(
        angle: -pi / 4,
        child: iconWidget,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Ícone do Card
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: iconWidget),
            ),
            const SizedBox(width: 16),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                ],
              ),
            ),

            // Seta (Chevron)
            Icon(
              Icons.chevron_right_rounded,
              color: chevronColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}