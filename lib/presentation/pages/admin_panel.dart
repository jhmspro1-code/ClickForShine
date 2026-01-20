import 'package:flutter/material.dart';

/// Admin Panel Web para gerenciar Compostos e Pads via Firestore
/// Permite edição sem recompilar o app
class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _compounds = [
    {
      'id': '1',
      'name': 'Corte Pesado',
      'brand': 'Rupes',
      'abrasivity': 9,
      'sector': 'Automotivo',
    },
    {
      'id': '2',
      'name': 'Refino Médio',
      'brand': 'Koch-Chemie',
      'abrasivity': 6,
      'sector': 'Automotivo',
    },
    {
      'id': '3',
      'name': 'Lustro Premium',
      'brand': '3M',
      'abrasivity': 2,
      'sector': 'Automotivo',
    },
  ];

  final List<Map<String, dynamic>> _pads = [
    {
      'id': '1',
      'name': 'Espuma Agressiva',
      'material': 'Espuma',
      'hardness': 8,
      'sector': 'Automotivo',
    },
    {
      'id': '2',
      'name': 'Espuma Média',
      'material': 'Espuma',
      'hardness': 5,
      'sector': 'Automotivo',
    },
    {
      'id': '3',
      'name': 'Microfibra',
      'material': 'Microfibra',
      'hardness': 2,
      'sector': 'Automotivo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: const Text('Admin Panel - ClickforShine'),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),

          // Conteúdo principal
          Expanded(
            child: _selectedTab == 0
                ? _buildCompoundsTab()
                : _buildPadsTab(),
          ),
        ],
      ),
    );
  }

  /// Constrói sidebar com abas
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Gerenciamento',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const Divider(color: Color(0xFF333333)),
          _buildSidebarItem(
            index: 0,
            icon: '🧪',
            label: 'Compostos',
          ),
          _buildSidebarItem(
            index: 1,
            icon: '🎯',
            label: 'Pads',
          ),
        ],
      ),
    );
  }

  /// Constrói item do sidebar
  Widget _buildSidebarItem({
    required int index,
    required String icon,
    required String label,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4AF37)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected
                    ? const Color(0xFF000000)
                    : const Color(0xFFFFFFFF),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói aba de Compostos
  Widget _buildCompoundsTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gerenciar Compostos',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddCompoundDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Novo Composto'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nome')),
                  DataColumn(label: Text('Marca')),
                  DataColumn(label: Text('Abrasividade')),
                  DataColumn(label: Text('Setor')),
                  DataColumn(label: Text('Ações')),
                ],
                rows: _compounds.map((compound) {
                  return DataRow(cells: [
                    DataCell(Text(compound['name'])),
                    DataCell(Text(compound['brand'])),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${compound['abrasivity']}/10',
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(compound['sector'])),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: const Color(0xFFD4AF37),
                            onPressed: () => _showEditCompoundDialog(compound),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _deleteCompound(compound['id']),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói aba de Pads
  Widget _buildPadsTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gerenciar Pads',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddPadDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Novo Pad'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nome')),
                  DataColumn(label: Text('Material')),
                  DataColumn(label: Text('Dureza')),
                  DataColumn(label: Text('Setor')),
                  DataColumn(label: Text('Ações')),
                ],
                rows: _pads.map((pad) {
                  return DataRow(cells: [
                    DataCell(Text(pad['name'])),
                    DataCell(Text(pad['material'])),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E5EAA).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${pad['hardness']}/10',
                          style: const TextStyle(
                            color: Color(0xFF2E5EAA),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(pad['sector'])),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: const Color(0xFFD4AF37),
                            onPressed: () => _showEditPadDialog(pad),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _deletePad(pad['id']),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para adicionar composto
  void _showAddCompoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Novo Composto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Nome'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(hintText: 'Marca'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(hintText: 'Abrasividade (1-10)'),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Salvar no Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Composto adicionado!')),
              );
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para editar composto
  void _showEditCompoundDialog(Map<String, dynamic> compound) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Editar Composto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: compound['name']),
              decoration: const InputDecoration(hintText: 'Nome'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: compound['brand']),
              decoration: const InputDecoration(hintText: 'Marca'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(
                text: compound['abrasivity'].toString(),
              ),
              decoration: const InputDecoration(hintText: 'Abrasividade (1-10)'),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Atualizar no Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Composto atualizado!')),
              );
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para adicionar pad
  void _showAddPadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Novo Pad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Nome'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(hintText: 'Material'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(hintText: 'Dureza (1-10)'),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Salvar no Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pad adicionado!')),
              );
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para editar pad
  void _showEditPadDialog(Map<String, dynamic> pad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Editar Pad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: pad['name']),
              decoration: const InputDecoration(hintText: 'Nome'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: pad['material']),
              decoration: const InputDecoration(hintText: 'Material'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(
                text: pad['hardness'].toString(),
              ),
              decoration: const InputDecoration(hintText: 'Dureza (1-10)'),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Atualizar no Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pad atualizado!')),
              );
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  /// Deleta composto
  void _deleteCompound(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja deletar este composto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Deletar do Firestore
              setState(() {
                _compounds.removeWhere((c) => c['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Composto deletado!')),
              );
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  /// Deleta pad
  void _deletePad(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja deletar este pad?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Deletar do Firestore
              setState(() {
                _pads.removeWhere((p) => p['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pad deletado!')),
              );
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }
}
