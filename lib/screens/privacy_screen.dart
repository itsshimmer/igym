import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _publicProfile = false;
  bool _shareProgress = true;
  bool _usageAnalytics = true;

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16161A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.download_rounded, color: Color(0xFF8C52FF)),
            SizedBox(width: 10),
            Text('Exportar Dados', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Enviaremos um arquivo JSON contendo todo o seu histórico de treinos, perfil e preferências para o seu e-mail cadastrado.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
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
                  content: Text('Solicitação enviada! Verifique seu e-mail em instantes.'),
                  backgroundColor: Color(0xFF65C48C),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Exportar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTermsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16161A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
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
              const Text(
                'Termos e Privacidade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '1. Coleta de Dados\n'
                'O iGym coleta dados estritamente necessários para o funcionamento do aplicativo, como nome, e-mail e informações sobre prescrição e execução de treinos.\n\n'
                '2. Uso das Informações\n'
                'Seus dados são utilizados para permitir a sincronização entre alunos e personal trainers, oferecendo uma experiência personalizada de treino.\n\n'
                '3. Compartilhamento de Dados\n'
                'Não vendemos ou compartilhamos suas informações pessoais com terceiros. Seus treinos só são visíveis para você e seu professor vinculado.\n\n'
                '4. Segurança\n'
                'Utilizamos infraestrutura em nuvem segura com criptografia ponta a ponta para proteger todas as suas informações.\n\n'
                '5. Direitos do Usuário\n'
                'Você pode alterar, solicitar exportação ou exclusão total de seus dados a qualquer momento nas configurações do app.',
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
                child: const Text('Entendi', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final deleteController = TextEditingController();
    bool canConfirm = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF16161A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFE55353)),
              SizedBox(width: 10),
              Text('Excluir Conta', style: TextStyle(color: Color(0xFFE55353), fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Esta ação é irreversível. Todos os seus dados, histórico e vínculos serão apagados permanentemente.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'Digite DELETAR para confirmar:',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: deleteController,
                style: const TextStyle(color: Colors.white),
                onChanged: (val) {
                  setState(() {
                    canConfirm = val.trim().toUpperCase() == 'DELETAR';
                  });
                },
                decoration: InputDecoration(
                  hintText: 'DELETAR',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF0F0E13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF28282D)),
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
                backgroundColor: canConfirm ? const Color(0xFFE55353) : Colors.grey.shade800,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: canConfirm
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sua solicitação de exclusão foi recebida.'),
                          backgroundColor: Color(0xFFE55353),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  : null,
              child: const Text('Excluir Conta', style: TextStyle(color: Colors.white)),
            ),
          ],
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
          'Privacidade',
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('PRIVACIDADE DE DADOS'),
              _buildSettingsGroup(
                children: [
                  _buildSwitchItem(
                    icon: Icons.visibility_outlined,
                    iconColor: const Color(0xFF8C52FF),
                    title: 'Perfil Público',
                    subtitle: 'Permitir que outros vejam seu perfil',
                    value: _publicProfile,
                    onChanged: (val) => setState(() => _publicProfile = val),
                  ),
                  _buildSwitchItem(
                    icon: Icons.share_outlined,
                    iconColor: const Color(0xFF65C48C),
                    title: 'Compartilhar Progresso',
                    subtitle: 'Permitir que seu professor acompanhe seu histórico',
                    value: _shareProgress,
                    onChanged: (val) => setState(() => _shareProgress = val),
                  ),
                  _buildSwitchItem(
                    icon: Icons.analytics_outlined,
                    iconColor: const Color(0xFFE5A444),
                    title: 'Análise de Uso',
                    subtitle: 'Enviar dados anônimos para melhorias',
                    value: _usageAnalytics,
                    onChanged: (val) => setState(() => _usageAnalytics = val),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('GERENCIAMENTO DE DADOS'),
              _buildSettingsGroup(
                children: [
                  _buildSettingsItem(
                    icon: Icons.download_rounded,
                    iconColor: const Color(0xFF4DB6AC),
                    title: 'Exportar Meus Dados',
                    subtitle: 'Receba uma cópia das suas informações',
                    onTap: _showExportDataDialog,
                  ),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFFFFD54F),
                    title: 'Termos e Política de Privacidade',
                    subtitle: 'Leia nossas regras e políticas',
                    onTap: _showTermsModal,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('ZONA DE PERIGO'),
              _buildSettingsGroup(
                children: [
                  _buildSettingsItem(
                    icon: Icons.delete_outline_rounded,
                    iconColor: const Color(0xFFE55353),
                    title: 'Excluir Minha Conta',
                    subtitle: 'Apagar permanentemente seus dados',
                    onTap: _showDeleteAccountDialog,
                    isDanger: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
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
    bool isDanger = false,
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
                    style: TextStyle(
                      color: isDanger ? const Color(0xFFE55353) : Colors.white,
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
