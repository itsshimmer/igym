import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _showTextModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16161A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C52FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Sobre o iGym',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo do App
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8C52FF), Color(0xFF5A44E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8C52FF).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'iGym',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF16161A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF28282D)),
                ),
                child: Text(
                  'Versão 1.0.0 (Build 100)',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Descrição
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF16161A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF28282D)),
                ),
                child: Text(
                  'O iGym é a plataforma definitiva desenvolvida para conectar personal trainers e alunos. Com foco em simplicidade, elegância e eficiência, permitimos a prescrição e acompanhamento de treinos personalizados em tempo real.',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 14,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Links Informativos
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF16161A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF28282D)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.article_outlined, color: Color(0xFF8C52FF)),
                      title: const Text('Termos de Serviço',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade600),
                      onTap: () => _showTextModal(
                        context,
                        'Termos de Serviço',
                        'Ao utilizar o iGym, você concorda em cumprir nossas diretrizes de uso responsável. O aplicativo é fornecido para auxílio em atividades físicas e não substitui orientação médica profissional.',
                      ),
                    ),
                    Divider(color: Colors.grey.shade800, height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.shield_outlined, color: Color(0xFF65C48C)),
                      title: const Text('Política de Privacidade',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade600),
                      onTap: () => _showTextModal(
                        context,
                        'Política de Privacidade',
                        'Seus dados são protegidos com os mais altos padrões de segurança. Não compartilhamos informações pessoais com terceiros sem seu consentimento.',
                      ),
                    ),
                    Divider(color: Colors.grey.shade800, height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.code_rounded, color: Color(0xFFE5A444)),
                      title: const Text('Licenças de Código Aberto',
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade600),
                      onTap: () => _showTextModal(
                        context,
                        'Licenças de Código Aberto',
                        'iGym foi construído utilizando Flutter, Firebase e diversas bibliotecas open-source da comunidade Dart/Flutter.\n\n• Flutter (BSD 3-Clause)\n• Provider (MIT)\n• Firebase Core & Auth (Apache 2.0)\n• Cloud Firestore (Apache 2.0)',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Center(
                child: Column(
                  children: [
                    Text(
                      'Desenvolvido com 💜 por iGym Team',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '© 2025 iGym. Todos os direitos reservados.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
