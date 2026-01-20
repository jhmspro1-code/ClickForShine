import 'package:equatable/equatable.dart';

/// Resultado do cálculo de agressividade do SmartShine
class AggressivenessResult extends Equatable {
  /// Valor de agressividade calculado (0-10)
  final double aggressivenessScore;
  
  /// Nível de corte recomendado (0: Apenas Lustro, 1: Refino, 2: Corte Pesado, 3: Lixamento)
  final int cuttingLevel;
  
  /// Faixa de RPM recomendada
  final String rpmRange;
  
  /// Tipo de pad recomendado
  final String padType;
  
  /// Tipo de composto recomendado
  final String compoundType;
  
  /// Índice de segurança (0-10, onde 10 é mais seguro)
  final double safetyIndex;
  
  /// Descrição da recomendação
  final String description;
  
  /// Notas de segurança (especialmente para aeronáutico)
  final List<String> safetyNotes;

  const AggressivenessResult({
    required this.aggressivenessScore,
    required this.cuttingLevel,
    required this.rpmRange,
    required this.padType,
    required this.compoundType,
    required this.safetyIndex,
    required this.description,
    required this.safetyNotes,
  });

  @override
  List<Object?> get props => [
    aggressivenessScore,
    cuttingLevel,
    rpmRange,
    padType,
    compoundType,
    safetyIndex,
    description,
    safetyNotes,
  ];
}

/// Use case para calcular agressividade usando o algoritmo SmartShine
/// 
/// Fórmula: Agressividade = (S * 0.4) + (D * 0.6)
/// Onde:
/// - S: Dureza da Superfície (1-10)
/// - D: Nível de Dano (1-10)
class CalculateAggressivenessUseCase {
  /// Calcula a agressividade com base na dureza da superfície e nível de dano
  /// 
  /// [surfaceHardness]: Dureza da superfície (1-10)
  /// [damageLevel]: Nível de dano (1-10)
  /// [sector]: Setor (automotive, marine, aerospace, industrial)
  /// 
  /// Retorna [AggressivenessResult] com recomendações
  AggressivenessResult call({
    required double surfaceHardness,
    required double damageLevel,
    required String sector,
  }) {
    // Validar entrada
    final s = surfaceHardness.clamp(1.0, 10.0);
    final d = damageLevel.clamp(1.0, 10.0);

    // Algoritmo SmartShine: Agressividade = (S * 0.4) + (D * 0.6)
    final aggressivenessScore = (s * 0.4) + (d * 0.6);

    // Determinar nível de corte
    int cuttingLevel;
    String description;
    List<String> safetyNotes = [];

    if (aggressivenessScore < 3) {
      cuttingLevel = 0;
      description = 'Apenas Lustro e Proteção';
    } else if (aggressivenessScore < 5) {
      cuttingLevel = 1;
      description = 'Refino leve com composto suave';
    } else if (aggressivenessScore < 7) {
      cuttingLevel = 2;
      description = 'Corte pesado com composto agressivo';
    } else {
      cuttingLevel = 3;
      description = 'Lixamento + Corte pesado (dano severo)';
      safetyNotes.add('⚠️ Dano severo detectado - usar técnica profissional');
    }

    // Determinar recomendações por setor
    final (rpmRange, padType, compoundType, safetyIndex) = 
        _getSectorSpecificRecommendations(
          aggressivenessScore,
          cuttingLevel,
          sector,
        );

    // Adicionar notas de segurança específicas do setor
    if (sector == 'aerospace') {
      safetyNotes.add('🚨 CRÍTICO: Limite de remoção de material em áreas críticas');
      safetyNotes.add('🚨 Usar equipamento calibrado para aviação');
    } else if (sector == 'marine') {
      safetyNotes.add('⚠️ Ambiente marinho: verificar corrosão antes de polir');
    }

    return AggressivenessResult(
      aggressivenessScore: aggressivenessScore,
      cuttingLevel: cuttingLevel,
      rpmRange: rpmRange,
      padType: padType,
      compoundType: compoundType,
      safetyIndex: safetyIndex,
      description: description,
      safetyNotes: safetyNotes,
    );
  }

  /// Retorna recomendações específicas por setor
  /// Retorna: (rpmRange, padType, compoundType, safetyIndex)
  (String, String, String, double) _getSectorSpecificRecommendations(
    double aggressivenessScore,
    int cuttingLevel,
    String sector,
  ) {
    switch (sector.toLowerCase()) {
      case 'automotive':
        return _getAutomotiveRecommendations(aggressivenessScore, cuttingLevel);
      case 'marine':
        return _getMarineRecommendations(aggressivenessScore, cuttingLevel);
      case 'aerospace':
        return _getAerospaceRecommendations(aggressivenessScore, cuttingLevel);
      case 'industrial':
        return _getIndustrialRecommendations(aggressivenessScore, cuttingLevel);
      default:
        return ('1200-1800 RPM', 'Espuma Média', 'Refino', 7.0);
    }
  }

  /// Recomendações para setor Automotivo
  (String, String, String, double) _getAutomotiveRecommendations(
    double aggressivenessScore,
    int cuttingLevel,
  ) {
    if (cuttingLevel == 0) {
      return ('800-1200 RPM', 'Microfibra', 'Lustro Premium', 9.0);
    } else if (cuttingLevel == 1) {
      return ('1200-1600 RPM', 'Espuma Fina', 'Refino Suave', 8.0);
    } else if (cuttingLevel == 2) {
      return ('1600-2000 RPM', 'Espuma Média', 'Corte Médio', 6.5);
    } else {
      return ('2000-2500 RPM', 'Lã Agressiva', 'Corte Pesado', 5.0);
    }
  }

  /// Recomendações para setor Náutico
  (String, String, String, double) _getMarineRecommendations(
    double aggressivenessScore,
    int cuttingLevel,
  ) {
    if (cuttingLevel == 0) {
      return ('600-1000 RPM', 'Microfibra Marinha', 'Proteção UV', 9.5);
    } else if (cuttingLevel == 1) {
      return ('1000-1400 RPM', 'Espuma Fina', 'Refino Marinho', 8.5);
    } else if (cuttingLevel == 2) {
      return ('1400-1800 RPM', 'Espuma Média', 'Corte Gel Coat', 7.0);
    } else {
      return ('1800-2200 RPM', 'Lã Marinha', 'Corte Pesado Gel Coat', 5.5);
    }
  }

  /// Recomendações para setor Aeronáutico
  (String, String, String, double) _getAerospaceRecommendations(
    double aggressivenessScore,
    int cuttingLevel,
  ) {
    if (cuttingLevel == 0) {
      return ('500-800 RPM', 'Microfibra Aero', 'Proteção Aero', 10.0);
    } else if (cuttingLevel == 1) {
      return ('800-1200 RPM', 'Espuma Fina Aero', 'Refino Aero', 9.0);
    } else if (cuttingLevel == 2) {
      return ('1200-1600 RPM', 'Espuma Média Aero', 'Corte Aero', 7.5);
    } else {
      return ('1600-2000 RPM', 'Lã Aero', 'Corte Pesado Aero', 6.0);
    }
  }

  /// Recomendações para setor Industrial
  (String, String, String, double) _getIndustrialRecommendations(
    double aggressivenessScore,
    int cuttingLevel,
  ) {
    if (cuttingLevel == 0) {
      return ('1000-1400 RPM', 'Microfibra Industrial', 'Proteção Industrial', 8.5);
    } else if (cuttingLevel == 1) {
      return ('1400-1800 RPM', 'Espuma Fina', 'Refino Industrial', 7.5);
    } else if (cuttingLevel == 2) {
      return ('1800-2200 RPM', 'Espuma Média', 'Corte Industrial', 6.0);
    } else {
      return ('2200-2800 RPM', 'Lã Agressiva', 'Corte Pesado Industrial', 4.5);
    }
  }
}
