import 'package:equatable/equatable.dart';

/// Contexto da análise anterior para o chat
/// 
/// Armazena metadados da última foto analisada para que o chat
/// possa responder com base técnica específica.
class AnalysisContext extends Equatable {
  /// ID único da análise
  final String analysisId;

  /// Tipo de superfície detectada
  final String surfaceType;

  /// Marca/modelo do veículo/embarcação (ex: BMW M340i, Azimut 60)
  final String? brandModel;

  /// Lista de defeitos detectados
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

  /// Setor (automotive, marine, aerospace, industrial)
  final String sector;

  /// Índice de segurança (0-10)
  final double safetyIndex;

  /// Advertências de segurança aplicáveis
  final List<String> safetyWarnings;

  /// Tempo estimado de trabalho (minutos)
  final int estimatedWorkTime;

  /// Custo estimado (relativo)
  final double estimatedCost;

  /// Confiança da análise (0-1)
  final double analysisConfidence;

  /// Timestamp da análise
  final DateTime analysisTimestamp;

  /// Notas técnicas adicionais
  final String? technicalNotes;

  const AnalysisContext({
    required this.analysisId,
    required this.surfaceType,
    this.brandModel,
    required this.defects,
    required this.hardnessScore,
    required this.damageLevel,
    required this.aggressivenessScore,
    required this.rpmRange,
    required this.padType,
    required this.compoundType,
    required this.sector,
    required this.safetyIndex,
    required this.safetyWarnings,
    required this.estimatedWorkTime,
    required this.estimatedCost,
    required this.analysisConfidence,
    required this.analysisTimestamp,
    this.technicalNotes,
  });

  @override
  List<Object?> get props => [
    analysisId,
    surfaceType,
    brandModel,
    defects,
    hardnessScore,
    damageLevel,
    aggressivenessScore,
    rpmRange,
    padType,
    compoundType,
    sector,
    safetyIndex,
    safetyWarnings,
    estimatedWorkTime,
    estimatedCost,
    analysisConfidence,
    analysisTimestamp,
    technicalNotes,
  ];

  /// Gera um resumo técnico para o contexto do chat
  String getContextSummary() {
    return '''
Análise Técnica Recente:
- Superfície: $surfaceType
- Defeitos: ${defects.join(', ')}
- Dureza: $hardnessScore/10
- Dano: $damageLevel/10
- Agressividade: $aggressivenessScore/10
- Setup: $rpmRange RPM, $padType, $compoundType
- Setor: $sector
- Segurança: $safetyIndex/10
- Tempo estimado: $estimatedWorkTime minutos
''';
  }
}

/// Mensagem de chat
class ChatMessage extends Equatable {
  /// ID único da mensagem
  final String messageId;

  /// Conteúdo da mensagem
  final String content;

  /// Remetente (user, assistant, system)
  final String role;

  /// Timestamp da mensagem
  final DateTime timestamp;

  /// Se é uma resposta em stream
  final bool isStreaming;

  /// Contexto técnico associado (se aplicável)
  final AnalysisContext? context;

  /// Fonte de conhecimento (openai, azure, google, manual)
  final String? knowledgeSource;

  /// Confiança da resposta (0-1)
  final double? responseConfidence;

  const ChatMessage({
    required this.messageId,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isStreaming = false,
    this.context,
    this.knowledgeSource,
    this.responseConfidence,
  });

  @override
  List<Object?> get props => [
    messageId,
    content,
    role,
    timestamp,
    isStreaming,
    context,
    knowledgeSource,
    responseConfidence,
  ];

  /// Retorna true se é mensagem do usuário
  bool get isUserMessage => role == 'user';

  /// Retorna true se é mensagem do assistente
  bool get isAssistantMessage => role == 'assistant';

  /// Retorna true se é mensagem do sistema
  bool get isSystemMessage => role == 'system';
}

/// Histórico de chat com contexto
class ChatHistory extends Equatable {
  /// Lista de mensagens
  final List<ChatMessage> messages;

  /// Contexto técnico atual
  final AnalysisContext? currentContext;

  /// Modo de conversa (technical, casual, sales)
  final String conversationMode;

  /// Idioma (pt, en, es)
  final String language;

  const ChatHistory({
    required this.messages,
    this.currentContext,
    this.conversationMode = 'technical',
    this.language = 'pt',
  });

  @override
  List<Object?> get props => [
    messages,
    currentContext,
    conversationMode,
    language,
  ];

  /// Retorna as últimas N mensagens
  List<ChatMessage> getLastMessages(int count) {
    if (messages.length <= count) return messages;
    return messages.sublist(messages.length - count);
  }

  /// Retorna o histórico formatado para o contexto da API
  List<Map<String, String>> getFormattedHistory() {
    return messages.map((msg) => {
      'role': msg.role,
      'content': msg.content,
    }).toList();
  }

  /// Adiciona uma nova mensagem
  ChatHistory addMessage(ChatMessage message) {
    return ChatHistory(
      messages: [...messages, message],
      currentContext: currentContext,
      conversationMode: conversationMode,
      language: language,
    );
  }

  /// Limpa o histórico
  ChatHistory clearHistory() {
    return ChatHistory(
      messages: [],
      currentContext: currentContext,
      conversationMode: conversationMode,
      language: language,
    );
  }
}
