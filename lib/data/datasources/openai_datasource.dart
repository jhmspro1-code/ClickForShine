import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';

/// Modelo de resposta do OpenAI
class OpenAIResponse {
  /// Laudo técnico gerado
  final String technicalReport;

  /// Recomendações profissionais
  final List<String> recommendations;

  /// Advertências de segurança
  final List<String> safetyWarnings;

  /// Estimativa de tempo de trabalho (em minutos)
  final int estimatedWorkTime;

  /// Custo estimado (em unidades relativas)
  final double estimatedCost;

  const OpenAIResponse({
    required this.technicalReport,
    required this.recommendations,
    required this.safetyWarnings,
    required this.estimatedWorkTime,
    required this.estimatedCost,
  });
}

/// Datasource para integração com OpenAI GPT-4
/// 
/// Gera laudos técnicos profissionais e persuasivos para o cliente final.
class OpenAIDatasource {
  final Dio _dio;
  final String _apiKey = EnvConfig.openaiApiKey;
  final String _model = EnvConfig.openaiModel;
  static const String _baseUrl = 'https://api.openai.com/v1';

  OpenAIDatasource({Dio? dio}) : _dio = dio ?? Dio();

  /// Gera um laudo técnico profissional baseado no diagnóstico
  /// 
  /// Retorna [OpenAIResponse] com laudo, recomendações e avisos
  Future<OpenAIResponse> generateTechnicalReport({
    required String surfaceType,
    required List<String> detectedDefects,
    required double hardnessScore,
    required double damageLevel,
    required double aggressivenessScore,
    required String rpmRange,
    required String padType,
    required String compoundType,
    required String sector,
    required String clientName,
  }) async {
    try {
      // Validar chave de API
      if (_apiKey.contains('sk-your')) {
        throw Exception('OpenAI API key não configurada. '
            'Configure OPENAI_API_KEY em seu arquivo .env');
      }

      // Construir prompt profissional
      final prompt = _buildPrompt(
        surfaceType: surfaceType,
        defects: detectedDefects,
        hardnessScore: hardnessScore,
        damageLevel: damageLevel,
        aggressivenessScore: aggressivenessScore,
        rpmRange: rpmRange,
        padType: padType,
        compoundType: compoundType,
        sector: sector,
        clientName: clientName,
      );

      // Chamar OpenAI API
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': _getSystemPrompt(),
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 1500,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Processar resposta
      return _processResponse(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao gerar laudo com OpenAI: ${e.message}');
    }
  }

  /// Constrói o prompt para o GPT-4
  String _buildPrompt({
    required String surfaceType,
    required List<String> defects,
    required double hardnessScore,
    required double damageLevel,
    required double aggressivenessScore,
    required String rpmRange,
    required String padType,
    required String compoundType,
    required String sector,
    required String clientName,
  }) {
    final defectsList = defects.join(', ');

    return '''
Gere um laudo técnico profissional e persuasivo para o cliente final baseado nos seguintes dados de diagnóstico:

DADOS TÉCNICOS:
- Cliente: $clientName
- Setor: $sector
- Tipo de Superfície: $surfaceType
- Defeitos Detectados: $defectsList
- Dureza da Superfície: $hardnessScore/10
- Nível de Dano: $damageLevel/10
- Agressividade do Setup: $aggressivenessScore/10

SETUP RECOMENDADO:
- RPM: $rpmRange
- Tipo de Pad: $padType
- Composto: $compoundType

INSTRUÇÕES:
1. Crie um laudo técnico em português, profissional e persuasivo
2. Explique os defeitos detectados em linguagem acessível
3. Justifique o setup recomendado com argumentos técnicos
4. Inclua recomendações de manutenção preventiva
5. Liste advertências de segurança se aplicável
6. Estime tempo de trabalho e custo relativo
7. Formato: JSON com campos: technicalReport, recommendations, safetyWarnings, estimatedWorkTime, estimatedCost

Responda APENAS em JSON válido, sem markdown ou explicações adicionais.
''';
  }

  /// Retorna o system prompt para o GPT-4
  String _getSystemPrompt() {
    return '''Você é um especialista técnico em polimento e detalhamento de superfícies com 20 anos de experiência. 
Sua tarefa é gerar laudos técnicos profissionais, precisos e persuasivos para clientes finais.
Use linguagem técnica mas acessível, sempre justificando as recomendações com argumentos sólidos.
Seja honesto sobre os riscos e sempre priorize a segurança do cliente.
Responda SEMPRE em JSON válido com a estrutura solicitada.''';
  }

  /// Processa a resposta do OpenAI
  OpenAIResponse _processResponse(Map<String, dynamic> response) {
    try {
      // Extrair conteúdo da resposta
      final content = response['choices']?[0]?['message']?['content'] ?? '{}';

      // Fazer parse do JSON
      final jsonData = _parseJsonResponse(content);

      return OpenAIResponse(
        technicalReport: jsonData['technicalReport'] ?? 'Laudo não gerado',
        recommendations: List<String>.from(jsonData['recommendations'] ?? []),
        safetyWarnings: List<String>.from(jsonData['safetyWarnings'] ?? []),
        estimatedWorkTime: jsonData['estimatedWorkTime'] ?? 120,
        estimatedCost: (jsonData['estimatedCost'] ?? 1.0).toDouble(),
      );
    } catch (e) {
      throw Exception('Erro ao processar resposta do OpenAI: $e');
    }
  }

  /// Faz parse seguro de JSON da resposta
  Map<String, dynamic> _parseJsonResponse(String content) {
    try {
      // Remover markdown code blocks se presentes
      var jsonString = content;
      if (jsonString.contains('```json')) {
        jsonString = jsonString.replaceAll('```json', '').replaceAll('```', '');
      } else if (jsonString.contains('```')) {
        jsonString = jsonString.replaceAll('```', '');
      }

      jsonString = jsonString.trim();

      // Fazer parse
      return Map<String, dynamic>.from(
        (jsonDecode(jsonString) as Map).cast<String, dynamic>(),
      );
    } catch (e) {
      // Se falhar, retornar estrutura padrão
      return {
        'technicalReport': content,
        'recommendations': [],
        'safetyWarnings': [],
        'estimatedWorkTime': 120,
        'estimatedCost': 1.0,
      };
    }
  }

  /// Gera recomendações de manutenção preventiva
  Future<List<String>> generateMaintenanceRecommendations({
    required String surfaceType,
    required String sector,
  }) async {
    try {
      final prompt = '''
Gere 5 recomendações de manutenção preventiva para manter uma superfície de $surfaceType 
no setor $sector em perfeito estado. Respostas breves e práticas.
Responda como um JSON array de strings.
''';

      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.5,
          'max_tokens': 500,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      final content = response.data['choices']?[0]?['message']?['content'] ?? '[]';
      final jsonArray = jsonDecode(content);

      return List<String>.from(jsonArray);
    } catch (e) {
      return [
        'Realizar limpeza regular com produtos apropriados',
        'Evitar exposição prolongada a elementos corrosivos',
        'Aplicar proteção UV regularmente',
        'Inspecionar mensalmente para detectar danos precoces',
        'Realizar polimento preventivo a cada 6 meses',
      ];
    }
  }

  /// Testa a conexão com OpenAI
  Future<bool> testConnection() async {
    try {
      if (_apiKey.contains('sk-your')) {
        return false;
      }

      final response = await _dio.get(
        '$_baseUrl/models',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// Importar jsonDecode
import 'dart:convert';
