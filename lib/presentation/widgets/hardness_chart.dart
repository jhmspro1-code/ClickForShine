import 'package:flutter/material.dart';

/// Widget customizado para exibir gráfico de dureza interativo
/// Utiliza CustomPainter para renderizar as barras com animação
class HardnessChart extends StatefulWidget {
  /// Dureza da superfície (0-10)
  final double surfaceHardness;
  
  /// Agressividade do setup (0-10)
  final double setupAggressiveness;
  
  /// Duração da animação
  final Duration animationDuration;

  const HardnessChart({
    Key? key,
    required this.surfaceHardness,
    required this.setupAggressiveness,
    this.animationDuration = const Duration(milliseconds: 1200),
  }) : super(key: key);

  @override
  State<HardnessChart> createState() => _HardnessChartState();
}

class _HardnessChartState extends State<HardnessChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(HardnessChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surfaceHardness != widget.surfaceHardness ||
        oldWidget.setupAggressiveness != widget.setupAggressiveness) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              'Análise de Dureza',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Gráfico
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF333333),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Barras do gráfico
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Barra de Dureza da Superfície
                      _buildBar(
                        label: 'Dureza da\nSuperfície',
                        value: widget.surfaceHardness,
                        color: const Color(0xFF2E5EAA),
                        animationValue: _animation.value,
                      ),
                      // Barra de Agressividade do Setup
                      _buildBar(
                        label: 'Agressividade\ndo Setup',
                        value: widget.setupAggressiveness,
                        color: const Color(0xFFD4AF37),
                        animationValue: _animation.value,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Legenda
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(
                        color: const Color(0xFF2E5EAA),
                        label: 'Dureza da Superfície',
                      ),
                      const SizedBox(width: 32),
                      _buildLegendItem(
                        color: const Color(0xFFD4AF37),
                        label: 'Agressividade do Setup',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Informações de compatibilidade
            _buildCompatibilityInfo(context),
          ],
        );
      },
    );
  }

  /// Constrói uma barra do gráfico com animação
  Widget _buildBar({
    required String label,
    required double value,
    required Color color,
    required double animationValue,
  }) {
    final animatedValue = value * animationValue;
    final maxHeight = 200.0;
    final barHeight = (animatedValue / 10) * maxHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Valor numérico
        Text(
          '${animatedValue.toStringAsFixed(1)}/10',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Barra
        Container(
          width: 60,
          height: barHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Label
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// Constrói item da legenda
  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// Constrói informações de compatibilidade
  Widget _buildCompatibilityInfo(BuildContext context) {
    final difference = (widget.setupAggressiveness - widget.surfaceHardness).abs();
    String compatibility;
    Color compatibilityColor;

    if (difference < 2) {
      compatibility = '✅ Compatibilidade Excelente';
      compatibilityColor = const Color(0xFF4ADE80);
    } else if (difference < 4) {
      compatibility = '⚠️ Compatibilidade Boa';
      compatibilityColor = const Color(0xFFFBBF24);
    } else {
      compatibility = '❌ Compatibilidade Baixa - Risco de Dano';
      compatibilityColor = const Color(0xFFF87171);
    }

    return Container(
      decoration: BoxDecoration(
        color: compatibilityColor.withOpacity(0.1),
        border: Border.all(
          color: compatibilityColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            compatibility,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: compatibilityColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Diferença: ${difference.toStringAsFixed(1)} pontos',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: compatibilityColor,
            ),
          ),
        ],
      ),
    );
  }
}
