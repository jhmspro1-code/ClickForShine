import 'package:flutter/material.dart';

/// Admin Dashboard - Painel de Controle para Gerenciar Presets
/// 
/// Permite editar:
/// - Tabelas de dureza por tipo de verniz
/// - Presets de RPM por setor
/// - Compostos e pads disponíveis
/// - Alertas de segurança
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClickforShine - Admin Dashboard'),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: const Color(0xFF1A1A1A),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSidebarItem(0, '📊 Dashboard', Icons.dashboard),
                _buildSidebarItem(1, '💎 Dureza de Vernizes', Icons.bar_chart),
                _buildSidebarItem(2, '⚙️ Presets de RPM', Icons.settings),
                _buildSidebarItem(3, '🧪 Compostos', Icons.science),
                _buildSidebarItem(4, '🎨 Pads/Boinas', Icons.palette),
                _buildSidebarItem(5, '⚠️ Alertas de Segurança', Icons.warning),
                _buildSidebarItem(6, '📱 Setores', Icons.category),
                const Divider(color: Color(0xFF333333)),
                _buildSidebarItem(7, '🔐 Configurações', Icons.security),
                _buildSidebarItem(8, '📊 Relatórios', Icons.assessment),
              ],
            ),
          ),
          // Conteúdo Principal
          Expanded(
            child: Container(
              color: const Color(0xFF000000),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF000000) : const Color(0xFFD4AF37),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF000000) : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildDashboardOverview();
      case 1:
        return _buildHardnessManager();
      case 2:
        return _buildRpmPresetsManager();
      case 3:
        return _buildCompoundsManager();
      case 4:
        return _buildPadsManager();
      case 5:
        return _buildSafetyAlertsManager();
      case 6:
        return _buildSectorsManager();
      case 7:
        return _buildSettings();
      case 8:
        return _buildReports();
      default:
        return _buildDashboardOverview();
    }
  }

  Widget _buildDashboardOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Administrativo',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard('Total de Vernizes', '24', Icons.palette),
              _buildStatCard('Compostos Ativos', '18', Icons.science),
              _buildStatCard('Pads Disponíveis', '12', Icons.category),
              _buildStatCard('Setores', '4', Icons.map),
              _buildStatCard('Alertas de Segurança', '8', Icons.warning),
              _buildStatCard('Usuários Ativos', '156', Icons.people),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Ações Rápidas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionButton('➕ Adicionar Verniz', () {}),
              const SizedBox(width: 16),
              _buildActionButton('➕ Adicionar Composto', () {}),
              const SizedBox(width: 16),
              _buildActionButton('📊 Exportar Dados', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD4AF37),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF000000)),
      ),
    );
  }

  Widget _buildHardnessManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Dureza de Vernizes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Tipo de Verniz', 'Dureza (1-10)', 'Setor', 'Ações'],
            rows: [
              ['Clear Coat Soft', '4', 'Automotivo', '✏️ 🗑️'],
              ['Clear Coat Medium', '6', 'Automotivo', '✏️ 🗑️'],
              ['Clear Coat Hard', '8', 'Automotivo', '✏️ 🗑️'],
              ['Gel Coat ISO', '9', 'Náutico', '✏️ 🗑️'],
              ['Gel Coat NPG', '9', 'Náutico', '✏️ 🗑️'],
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('➕ Adicionar Novo Verniz', () {}),
        ],
      ),
    );
  }

  Widget _buildRpmPresetsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Presets de RPM',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Setor', 'Agressividade', 'RPM Min', 'RPM Max', 'Ações'],
            rows: [
              ['Automotivo', 'Baixa', '800', '1200', '✏️ 🗑️'],
              ['Automotivo', 'Média', '1200', '1800', '✏️ 🗑️'],
              ['Automotivo', 'Alta', '1800', '2500', '✏️ 🗑️'],
              ['Náutico', 'Média', '600', '1200', '✏️ 🗑️'],
              ['Náutico', 'Alta', '1200', '1800', '✏️ 🗑️'],
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('➕ Adicionar Novo Preset', () {}),
        ],
      ),
    );
  }

  Widget _buildCompoundsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Compostos',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Nome', 'Marca', 'Abrasividade', 'Setor', 'Ações'],
            rows: [
              ['Compound Cut', 'Rupes', 'Alta', 'Automotivo', '✏️ 🗑️'],
              ['Compound Refino', 'Koch-Chemie', 'Média', 'Automotivo', '✏️ 🗑️'],
              ['Lustro Premium', '3M', 'Baixa', 'Automotivo', '✏️ 🗑️'],
              ['Marine Cut', 'Rupes', 'Alta', 'Náutico', '✏️ 🗑️'],
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('➕ Adicionar Novo Composto', () {}),
        ],
      ),
    );
  }

  Widget _buildPadsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Pads/Boinas',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Nome', 'Material', 'Dureza', 'Setor', 'Ações'],
            rows: [
              ['Espuma Fina', 'Espuma', 'Macia', 'Automotivo', '✏️ 🗑️'],
              ['Espuma Média', 'Espuma', 'Média', 'Automotivo', '✏️ 🗑️'],
              ['Lã Natural', 'Lã', 'Dura', 'Automotivo', '✏️ 🗑️'],
              ['Microfibra', 'Microfibra', 'Macia', 'Náutico', '✏️ 🗑️'],
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('➕ Adicionar Novo Pad', () {}),
        ],
      ),
    );
  }

  Widget _buildSafetyAlertsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Alertas de Segurança',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Alerta', 'Setor', 'Nível', 'Ações'],
            rows: [
              ['Não exceder 2500 RPM em verniz cerâmico', 'Automotivo', 'Crítico', '✏️ 🗑️'],
              ['Risco de corrosão em Gel Coat oxidado', 'Náutico', 'Alto', '✏️ 🗑️'],
              ['Proteger áreas críticas em aeronaves', 'Aeronáutico', 'Crítico', '✏️ 🗑️'],
              ['Usar EPI adequado', 'Industrial', 'Médio', '✏️ 🗑️'],
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('➕ Adicionar Novo Alerta', () {}),
        ],
      ),
    );
  }

  Widget _buildSectorsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Setores',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Setor', 'Descrição', 'Ativo', 'Ações'],
            rows: [
              ['Automotivo', 'Polimento de veículos', '✅', '✏️ 🗑️'],
              ['Náutico', 'Polimento de embarcações', '✅', '✏️ 🗑️'],
              ['Aeronáutico', 'Polimento de aeronaves', '✅', '✏️ 🗑️'],
              ['Industrial', 'Polimento industrial', '✅', '✏️ 🗑️'],
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('➕ Adicionar Novo Setor', () {}),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildSettingItem('Versão do App', 'v1.0.0'),
          _buildSettingItem('Última Atualização', '18/01/2024'),
          _buildSettingItem('Modo Debug', 'Desativado'),
          _buildSettingItem('Sincronização Firebase', 'Ativa'),
          const SizedBox(height: 24),
          _buildActionButton('🔄 Sincronizar Dados', () {}),
          const SizedBox(height: 12),
          _buildActionButton('💾 Fazer Backup', () {}),
        ],
      ),
    );
  }

  Widget _buildReports() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Relatórios',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildReportCard('Diagnósticos Realizados', '1,234', 'Últimos 30 dias'),
          _buildReportCard('Usuários Ativos', '156', 'Hoje'),
          _buildReportCard('Taxa de Sucesso', '98.5%', 'Análises'),
          _buildReportCard('Tempo Médio', '2.3 min', 'Por diagnóstico'),
        ],
      ),
    );
  }

  Widget _buildDataTable({
    required List<String> columns,
    required List<List<String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: columns.map((col) {
                return Expanded(
                  child: Text(
                    col,
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Rows
          ...rows.map((row) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF333333)),
                ),
              ),
              child: Row(
                children: row.map((cell) {
                  return Expanded(
                    child: Text(
                      cell,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
