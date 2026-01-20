import 'dart:typed_data';
import 'package:equatable/equatable.dart';

/// Resultado completo da análise com laudo gerado
class AnalysisAndReportResult extends Equatable {
  /// Tipo de superfície detectada
  final String surfaceType;

  /// Defeitos detectados
  final List<String> defects;

  /// Dureza da superfície (1-10)
  final double hardnessScore;

  /// Nível de dano (1-10)
  final double damageLevel;

  /// Agressividade do setup (1-10)
  final double aggressivenessScore;

  /// RPM recomendado
  final String rpmRange;

  /// Tipo de pad recomendado
  final String padType;

  /// Tipo de composto recomendado
  final String compoundType;

  /// Índice de segurança
  final double safetyIndex;

  /// Laudo técnico gerado por GPT-4
  final String technicalReport;

  /// Recomendações profissionais
  final List<String> recommendations;

  /// Advertências de segurança
  final List<String> safetyWarnings;

  /// Tempo estimado de trabalho (minutos)
  final int estimatedWorkTime;

  /// Custo estimado (relativo)
  final double estimatedCost;

  /// Confiança da análise (0-1)
  final double analysisConfidence;

  const AnalysisAndReportResult({
    required this.surfaceType,
    required this.defects,
    required this.hardnessScore,
    required this.damageLevel,
    required this.aggressivenessScore,
    required this.rpmRange,
    required this.padType,
    required this.compoundType,
    required this.safetyIndex,
    required this.technicalReport,
    required this.recommendations,
    required this.safetyWarnings,
    required this.estimatedWorkTime,
    required this.estimatedCost,
    required this.analysisConfidence,
  });

  @override
  List<Object?> get props => [
    surfaceType,
    defects,
    hardnessScore,
    damageLevel,
    aggressivenessScore,
    rpmRange,
    padType,
    compoundType,
    safetyIndex,
    technicalReport,
    recommendations,
    safetyWarnings,
    estimatedWorkTime,
    estimatedCost,
    analysisConfidence,
  ];
}

/// Use case que orquestra a análise completa:
/// 1. Azure Vision para análise de superfície
/// 2. SmartShine para cálculo de agressividade
/// 3. OpenAI GPT-4 para geração de laudo
class AnalyzeAndReportUseCase {
  /// Repositório de análise (injected)
  final dynamic analysisRepository;

  AnalyzeAndReportUseCase(this.analysisRepository);

  /// Executa análise completa de uma imagem
  /// 
  /// Fluxo:
  /// 1. Envia imagem para Azure Vision
  /// 2. Recebe análise de superfície e defeitos
  /// 3. Calcula dureza e dano
  /// 4. Aplica algoritmo SmartShine
  /// 5. Gera setup recomendado
  /// 6. Envia para OpenAI GPT-4
  /// 7. Retorna laudo completo
  Future<AnalysisAndReportResult> call({
    required Uint8List imageBytes,
    required String sector,
    required String clientName,
  }) async {
    try {
      // ETAPA 1: Análise com Azure Vision
      final azureAnalysis = await analysisRepository.analyzeWithAzure(
        imageBytes,
        sector: sector,
      );

      // ETAPA 2: Calcular agressividade com SmartShine
      final aggressivenessScore = 
          (azureAnalysis.hardnessLevel * 0.4) + 
          (azureAnalysis.damageLevel * 0.6);

      // ETAPA 3: Determinar setup recomendado
      final (rpmRange, padType, compoundType, safetyIndex) =
          _getRecommendedSetup(
            aggressivenessScore,
            azureAnalysis.hardnessLevel,
            sector,
          );

      // ETAPA 4: Gerar laudo com OpenAI GPT-4
      final openaiReport = await analysisRepository.generateReportWithOpenAI(
        surfaceType: azureAnalysis.surfaceType,
        defects: azureAnalysis.defects,
        hardnessScore: azureAnalysis.hardnessLevel,
        damageLevel: azureAnalysis.damageLevel,
        aggressivenessScore: aggressivenessScore,
        rpmRange: rpmRange,
        padType: padType,
        compoundType: compoundType,
        sector: sector,
        clientName: clientName,
      );

      // ETAPA 5: Combinar resultados
      return AnalysisAndReportResult(
        surfaceType: azureAnalysis.surfaceType,
        defects: azureAnalysis.defects,
        hardnessScore: azureAnalysis.hardnessLevel,
        damageLevel: azureAnalysis.damageLevel,
        aggressivenessScore: aggressivenessScore,
        rpmRange: rpmRange,
        padType: padType,
        compoundType: compoundType,
        safetyIndex: safetyIndex,
        technicalReport: openaiReport.technicalReport,
        recommendations: openaiReport.recommendations,
        safetyWarnings: openaiReport.safetyWarnings,
        estimatedWorkTime: openaiReport.estimatedWorkTime,
        estimatedCost: openaiReport.estimatedCost,
        analysisConfidence: azureAnalysis.confidence,
      );
    } catch (e) {
      throw Exception('Erro na análise completa: $e');
    }
  }

  /// Determina o setup recomendado baseado na agressividade
  (String, String, String, double) _getRecommendedSetup(
    double aggressivenessScore,
    double hardnessLevel,
    String sector,
  ) {
    // Calcular índice de segurança
    final safetyIndex = (10 - (aggressivenessScore * 0.8)).clamp(0.0, 10.0);

    // Determinar nível de corte
    int cuttingLevel;
    if (aggressivenessScore < 3) {
      cuttingLevel = 0;
    } else if (aggressivenessScore < 5) {
      cuttingLevel = 1;
    } else if (aggressivenessScore < 7) {
      cuttingLevel = 2;
    } else {
      cuttingLevel = 3;
    }

    // Buscar recomendações por setor
    final (rpmRange, padType, compoundType) =
        _getSectorSpecificSetup(aggressivenessScore, cuttingLevel, sector);

    return (rpmRange, padType, compoundType, safetyIndex);
  }

  /// Retorna setup específico por setor
  (String, String, String) _getSectorSpecificSetup(
    double aggressivenessScore,
    int cuttingLevel,
    String sector,
  ) {
    switch (sector.toLowerCase()) {
      case 'automotive':
        return _getAutomotiveSetup(aggressivenessScore, cuttingLevel);
      case 'marine':
        return _getMarineSetup(aggressivenessScore, cuttingLevel);
      case 'aerospace':
        return _getAerospaceSetup(aggressivenessScore, cuttingLevel);
      case 'industrial':
        return _getIndustrialSetup(aggressivenessScore, cuttingLevel);
      default:
        return ('1200-1800 RPM', 'Espuma Média', 'Refino');
    }
  }

  (String, String, String) _getAutomotiveSetup(
    double aggressivenessScore,
    int cuttingLevel,
  ) {
    if (cuttingLevel == 0) {
      return ('800-1200 RPM', 'Microfibra', 'Lustro Premium');
    } else if (cuttingLevel == 1) {
      return ('1200-1600 RPM', 'Espuma Fina', 'Refino Suave');
    } else if (cuttingLevel == 2) {
      return ('1600-2000 RPM', 'Espuma Média', 'Corte Médio');
    } else {
      return ('2000-2500 RPM', 'Lã Agressiva', 'Corte Pesado');
    }
  }

  (String, String, String) _getMarineSetup(
    double aggressivenessScore,
    int cuttingLevel,
  ) {
    if (cuttingLevel == 0) {
      return ('600-1000 RPM', 'Microfibra Marinha', 'Proteção UV');
    } else if (cuttingLevel == 1) {
      return ('1000-1400 RPM', 'Espuma Fina', 'Refino Marinho');
    } else if (cuttingLevel == 2) {
      return ('1400-1800 RPM', 'Espuma Média', 'Corte Gel Coat');
    } else {
      return ('1800-2200 RPM', 'Lã Marinha', 'Corte Pesado');
    }
  }

  (String, String, String) _getAerospaceSetup(
    double aggressivenessScore,
    int cuttingLevel,
  ) {
    if (cuttingLevel == 0) {
      return ('500-800 RPM', 'Microfibra Aero', 'Proteção Aero');
    } else if (cuttingLevel == 1) {
      return ('800-1200 RPM', 'Espuma Fina Aero', 'Refino Aero');
    } else if (cuttingLevel == 2) {
      return ('1200-1600 RPM', 'Espuma Média Aero', 'Corte Aero');
    } else {
      return ('1600-2000 RPM', 'Lã Aero', 'Corte Pesado Aero');
    }
  }

  (String, String, String) _getIndustrialSetup(
    double aggressivenessScore,
    int cuttingLevel,
  ) {
    if (cuttingLevel == 0) {
      return ('1000-1400 RPM', 'Microfibra Industrial', 'Proteção Industrial');
    } else if (cuttingLevel == 1) {
      return ('1400-1800 RPM', 'Espuma Fina', 'Refino Industrial');
    } else if (cuttingLevel == 2) {
      return ('1800-2200 RPM', 'Espuma Média', 'Corte Industrial');
    } else {
      return ('2200-2800 RPM', 'Lã Agressiva', 'Corte Pesado');
    }
  }
}
