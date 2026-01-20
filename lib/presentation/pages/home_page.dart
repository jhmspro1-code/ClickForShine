import 'package:flutter/material.dart';

/// Página inicial com dashboard do ClickforShine
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedSectorIndex = 0;

  final List<Map<String, String>> _sectors = [
    {
      'name': 'Automotivo',
      'emoji': '🚗',
      'description': 'Vernizes, plásticos e revestimentos automotivos',
    },
    {
      'name': 'Náutico',
      'emoji': '⛵',
      'description': 'Gel Coat, madeiras nobres e embarcações',
    },
    {
      'name': 'Aeronáutico',
      'emoji': '✈️',
      'description': 'Alumínio, poliuretano e acrílicos de aviação',
    },
    {
      'name': 'Industrial',
      'emoji': '🏭',
      'description': 'Metais, pedras e resinas industriais',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 32),

                // Seletor de Setor
                _buildSectorSelector(),
                const SizedBox(height: 32),

                // Cards de Estatísticas
                _buildStatsCards(),
                const SizedBox(height: 32),

                // Botão de Novo Scan
                _buildNewScanButton(),
                const SizedBox(height: 32),

                // Histórico
                _buildHistorySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói header com título
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ClickforShine',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Diagnóstico Técnico de Polimento',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Constrói seletor de setor
  Widget _buildSectorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecione o Setor',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _sectors.length,
            itemBuilder: (context, index) {
              final sector = _sectors[index];
              final isSelected = _selectedSectorIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedSectorIndex = index);
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFF333333),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sector['emoji']!,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sector['name']!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? const Color(0xFF000000)
                              : const Color(0xFFD4AF37),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Constrói cards de estatísticas
  Widget _buildStatsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estatísticas',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Scans',
                value: '12',
                icon: '📊',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Média\nDureza',
                value: '6.5',
                icon: '💎',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói um card de estatística
  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  /// Constrói botão de novo scan
  Widget _buildNewScanButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Navegar para câmera
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abrindo câmera...')),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📸 '),
            Text(
              'Novo Scan',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF000000),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói seção de histórico
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico Recente',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF333333),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildHistoryItem(
                title: 'Verniz Alto Sólidos',
                sector: 'Automotivo',
                date: '15 Jan 2024',
                severity: 'Moderado',
              ),
              const Divider(color: Color(0xFF333333)),
              _buildHistoryItem(
                title: 'Gel Coat ISO',
                sector: 'Náutico',
                date: '14 Jan 2024',
                severity: 'Leve',
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Constrói item do histórico
  Widget _buildHistoryItem({
    required String title,
    required String sector,
    required String date,
    required String severity,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '$sector • $date',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: severity == 'Leve'
                  ? const Color(0xFF4ADE80).withOpacity(0.1)
                  : const Color(0xFFFBBF24).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              severity,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: severity == 'Leve'
                    ? const Color(0xFF4ADE80)
                    : const Color(0xFFFBBF24),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
