import 'package:equatable/equatable.dart';

/// Enum para setores especializados
enum SectorType {
  automotive('Automotivo', '🚗'),
  marine('Náutico', '⛵'),
  aerospace('Aeronáutico', '✈️'),
  industrial('Industrial', '🏭');

  final String label;
  final String emoji;
  const SectorType(this.label, this.emoji);
}

/// Enum para tipos de superfícies por setor
enum SurfaceType {
  // Automotivo
  clearcoatSoft('Verniz Macio', 'Soft clearcoat típico de carros asiáticos', 3),
  clearcoatMedium('Verniz Médio', 'Verniz padrão europeu', 5),
  clearcoatHard('Verniz Duro', 'Clearcoat de alta dureza', 7),
  ceramicCoating('Revestimento Cerâmico', 'Proteção cerâmica premium', 9),
  blackPiano('Black Piano', 'Plástico preto brilhante', 2),

  // Náutico
  gelCoatISO('Gel Coat ISO', 'Padrão internacional', 6),
  gelCoatNPG('Gel Coat NPG', 'Neopentyl Glycol - mais flexível', 5),
  gelCoatOrtho('Gel Coat Ortoftálico', 'Mais econômico', 4),
  teakWood('Madeira Teca', 'Verniz náutico em madeira nobre', 5),

  // Aeronáutico
  polishedAluminum('Alumínio Polido', 'Fuselagem de aeronaves', 5),
  aircraftPU('Poliuretano de Aviação', 'Pintura de proteção', 7),
  acrylicWindow('Acrílico de Janela', 'Janelas de cabine', 2),
  polycarbonateWindow('Policarbonato de Janela', 'Janelas resistentes', 3),

  // Industrial
  stainlessSteel('Aço Inoxidável', 'Muito duro e resistente', 8),
  bronze('Bronze', 'Metal nobre', 6),
  marble('Mármore', 'Pedra natural porosa', 3),
  granite('Granito', 'Pedra muito dura', 8),
  epoxyResin('Resina Epóxi', 'Revestimento industrial', 6);

  final String label;
  final String description;
  final int hardnessLevel; // 1-10
  const SurfaceType(this.label, this.description, this.hardnessLevel);
}

/// Enum para tipos de defeitos
enum DefectType {
  swirls('Swirls', 'Marcas de lavagem em padrão circular', 2),
  hologram('Holograma', 'Reflexo ondulado em luz LED', 3),
  scratches('Riscos', 'Riscos profundos (RIDs)', 5),
  oxidation('Oxidação', 'Oxidação superficial', 6),
  calcification('Calcinação', 'Depósitos minerais', 4),
  waterSpots('Manchas de Água', 'Depósitos de água seca', 2),
  delamination('Delaminação', 'Descamação do revestimento', 8),
  corrosion('Corrosão', 'Corrosão profunda', 9);

  final String label;
  final String description;
  final int severity; // 1-10
  const DefectType(this.label, this.description, this.severity);
}

/// Entidade que representa uma superfície analisada
class SurfaceEntity extends Equatable {
  final String id;
  final SectorType sector;
  final SurfaceType surfaceType;
  final List<DefectType> detectedDefects;
  final double hardnessScore; // 1-10
  final DateTime analyzedAt;
  final String? imageUrl;

  const SurfaceEntity({
    required this.id,
    required this.sector,
    required this.surfaceType,
    required this.detectedDefects,
    required this.hardnessScore,
    required this.analyzedAt,
    this.imageUrl,
  });

  /// Calcula o nível de dano baseado nos defeitos detectados
  double calculateDamageLevel() {
    if (detectedDefects.isEmpty) return 1.0;
    final avgSeverity = detectedDefects
        .map((d) => d.severity.toDouble())
        .reduce((a, b) => a + b) /
        detectedDefects.length;
    return avgSeverity.clamp(1.0, 10.0);
  }

  @override
  List<Object?> get props => [
    id,
    sector,
    surfaceType,
    detectedDefects,
    hardnessScore,
    analyzedAt,
    imageUrl,
  ];
}

/// Entidade que representa uma recomendação de correção
class CorrectionRecommendationEntity extends Equatable {
  final String id;
  final String surfaceId;
  final double aggressivenessScore;
  final String rpmRange;
  final String padType;
  final String compoundType;
  final double safetyIndex;
  final List<String> safetyNotes;
  final DateTime createdAt;

  const CorrectionRecommendationEntity({
    required this.id,
    required this.surfaceId,
    required this.aggressivenessScore,
    required this.rpmRange,
    required this.padType,
    required this.compoundType,
    required this.safetyIndex,
    required this.safetyNotes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    surfaceId,
    aggressivenessScore,
    rpmRange,
    padType,
    compoundType,
    safetyIndex,
    safetyNotes,
    createdAt,
  ];
}
