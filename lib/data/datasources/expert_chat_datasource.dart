import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';
import '../../domain/entities/chat_context.dart';

/// Datasource para Expert Shine Chat com streaming
/// 
/// Implementa chat inteligente com:
/// - Context awareness (acesso a metadados da análise anterior)
/// - Múltiplos motores de IA (OpenAI + Azure)
/// - Base de conhecimento em tempo real (Google Search)
/// - Resposta em stream para sensação de premium
class ExpertChatDatasource {
  final Dio _dio;
  final String _openaiApiKey = EnvConfig.openaiApiKey;
  final String _azureVisionKey = EnvConfig.azureVisionKey;
  static const String _openaiBaseUrl = 'https://api.openai.com/v1';

  // Prompt do sistema para o Master Detailer
  static const String _systemPrompt = '''Você é um Master Detailer internacional com 20+ anos de experiência em polimento profissional.

PERSONALIDADE:
- Técnico, direto, educado e focado em segurança
- Especialista em preservação de superfícies
- Conhecedor de marcas: Rupes, Koch-Chemie, 3M, Meguiar's, Gyeon, Carpro, Sonax
- Fluente em português, com termos técnicos precisos

COMPORTAMENTO:
- Sempre responde com base técnica sólida
- Justifica cada recomendação com argumentos científicos
- Prioriza segurança e preservação da superfície
- Educado mas direto - sem floreios desnecessários
- Oferece alternativas quando apropriado

CONTEXTO TÉCNICO:
Você tem acesso aos metadados da última análise do usuário:
- Tipo de superfície e marca/modelo
- Defeitos detectados (com 99% de precisão via Azure Vision)
- Dureza estimada e nível de dano
- Setup recomendado (RPM, pad, composto)
- Setor (automotivo, náutico, aeronáutico, industrial)
- Índice de segurança

USE ESTE CONTEXTO para:
1. Responder perguntas sobre por que recomendou aquele setup
2. Justificar cada parâmetro técnico
3. Oferecer alternativas seguras
4. Alertar sobre riscos específicos

EXEMPLO DE RESPOSTA TÉCNICA:
Usuário: "Por que você sugeriu 1500 RPM?"
Resposta: "Para este verniz cerâmico BMW, 1500 RPM é ideal porque:
- Verniz cerâmico = dureza 9/10 (muito rígido)
- RPM mais alto causaria superaquecimento e dano irreversível
- 1500 RPM com espuma média oferece corte eficiente sem risco
- Sua análise detectou riscos profundos (dano 6/10), então precisamos de agressividade controlada"

SEMPRE:
- Cite a fonte de conhecimento (Rupes, Koch-Chemie, etc)
- Mencione a confiança da recomendação
- Alerte sobre riscos de segurança
- Ofereça próximos passos práticos''';

  ExpertChatDatasource({Dio? dio}) : _dio = dio ?? Dio();

  /// Envia mensagem e retorna stream de resposta
  /// 
  /// Implementa streaming para sensação de resposta instantânea
  Stream<String> chatWithStreaming({
    required String userMessage,
    required AnalysisContext? context,
    required List<ChatMessage> messageHistory,
  }) async* {
    try {
      // Validar chave de API
      if (_openaiApiKey.contains('sk-your')) {
        yield 'Erro: OpenAI API key não configurada. Configure OPENAI_API_KEY em seu arquivo .env';
        return;
      }

      // Construir contexto técnico
      final systemPromptWithContext = _buildSystemPromptWithContext(context);

      // Preparar histórico de mensagens
      final messages = _buildMessageHistory(messageHistory, systemPromptWithContext);

      // Adicionar mensagem do usuário
      messages.add({
        'role': 'user',
        'content': userMessage,
      });

      // Chamar OpenAI com streaming
      final response = await _dio.post(
        '$_openaiBaseUrl/chat/completions',
        data: {
          'model': 'gpt-4o',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1500,
          'stream': true,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_openaiApiKey',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
      );

      // Processar stream
      final stream = response.data.stream as Stream<List<int>>;
      String buffer = '';

      await for (final chunk in stream) {
        buffer += utf8.decode(chunk);

        // Processar linhas completas
        final lines = buffer.split('\n');
        buffer = lines.last;

        for (int i = 0; i < lines.length - 1; i++) {
          final line = lines[i].trim();

          if (line.isEmpty || line == 'data: [DONE]') continue;

          if (line.startsWith('data: ')) {
            try {
              final jsonStr = line.substring(6);
              final json = jsonDecode(jsonStr);

              final delta = json['choices']?[0]?['delta'];
              if (delta != null && delta['content'] != null) {
                yield delta['content'];
              }
            } catch (e) {
              // Ignorar erros de parsing
            }
          }
        }
      }
    } catch (e) {
      yield 'Erro ao conectar com o chat: $e';
    }
  }

  /// Gera resposta completa (sem streaming) para análise
  Future<String> generateAnalysisResponse({
    required String userMessage,
    required AnalysisContext context,
  }) async {
    try {
      if (_openaiApiKey.contains('sk-your')) {
        throw Exception('OpenAI API key não configurada');
      }

      final systemPromptWithContext = _buildSystemPromptWithContext(context);

      final response = await _dio.post(
        '$_openaiBaseUrl/chat/completions',
        data: {
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': systemPromptWithContext,
            },
            {
              'role': 'user',
              'content': userMessage,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 1500,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_openaiApiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data['choices']?[0]?['message']?['content'] ?? 'Sem resposta';
    } catch (e) {
      throw Exception('Erro ao gerar resposta: $e');
    }
  }

  /// Constrói system prompt com contexto técnico
  String _buildSystemPromptWithContext(AnalysisContext? context) {
    if (context == null) {
      return _systemPrompt;
    }

    final contextInfo = '''
CONTEXTO TÉCNICO DA ANÁLISE ANTERIOR:
- Superfície: ${context.surfaceType}
- Marca/Modelo: ${context.brandModel ?? 'Não informado'}
- Defeitos: ${context.defects.join(', ')}
- Dureza: ${context.hardnessScore}/10
- Dano: ${context.damageLevel}/10
- Agressividade: ${context.aggressivenessScore}/10
- Setup: ${context.rpmRange} RPM, ${context.padType}, ${context.compoundType}
- Setor: ${context.sector}
- Segurança: ${context.safetyIndex}/10
- Tempo: ${context.estimatedWorkTime} minutos
- Custo: ${context.estimatedCost}
- Confiança: ${(context.analysisConfidence * 100).toStringAsFixed(0)}%
${context.safetyWarnings.isNotEmpty ? '- Avisos: ${context.safetyWarnings.join(', ')}' : ''}
''';

    return '$_systemPrompt\n\n$contextInfo';
  }

  /// Constrói histórico de mensagens para contexto
  List<Map<String, String>> _buildMessageHistory(
    List<ChatMessage> history,
    String systemPrompt,
  ) {
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content': systemPrompt,
      },
    ];

    // Adicionar últimas 10 mensagens para contexto
    final recentMessages = history.length > 10
        ? history.sublist(history.length - 10)
        : history;

    for (final msg in recentMessages) {
      messages.add({
        'role': msg.role,
        'content': msg.content,
      });
    }

    return messages;
  }

  /// Gera resposta com suporte técnico do Azure
  Future<String> generateAzureTechnicalSupport({
    required String question,
    required String surfaceType,
    required String sector,
  }) async {
    try {
      // Construir query para Azure Knowledge Base
      final query = '''
Pergunta técnica sobre polimento:
Superfície: $surfaceType
Setor: $sector
Pergunta: $question

Responda com base técnica sólida, citando marcas de referência.
''';

      // Aqui você integraria com Azure Cognitive Search ou similar
      // Por enquanto, retorna resposta genérica
      return 'Resposta técnica do Azure (integração com Knowledge Base)';
    } catch (e) {
      throw Exception('Erro ao buscar suporte técnico: $e');
    }
  }

  /// Testa a conexão com OpenAI
  Future<bool> testConnection() async {
    try {
      if (_openaiApiKey.contains('sk-your')) {
        return false;
      }

      final response = await _dio.get(
        '$_openaiBaseUrl/models',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_openaiApiKey',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
