import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';

/// Resultado de busca do Google
class SearchResult {
  /// Título do resultado
  final String title;

  /// URL da página
  final String url;

  /// Snippet/preview do conteúdo
  final String snippet;

  /// Fonte (marca, manual, etc)
  final String source;

  /// Relevância (0-1)
  final double relevance;

  const SearchResult({
    required this.title,
    required this.url,
    required this.snippet,
    required this.source,
    required this.relevance,
  });
}

/// Datasource para busca de conhecimento técnico via Google
/// 
/// Consulta em tempo real manuais de marcas como Rupes, Koch-Chemie,
/// 3M e Meguiar's para respostas embasadas.
class GoogleSearchDatasource {
  final Dio _dio;
  final String _apiKey = EnvConfig.googleCloudApiKey;
  final String _searchEngineId = 'your_custom_search_engine_id';

  // Marcas técnicas de referência
  static const List<String> technicalBrands = [
    'Rupes',
    'Koch-Chemie',
    '3M',
    "Meguiar's",
    'Gyeon',
    'Carpro',
    'Sonax',
  ];

  GoogleSearchDatasource({Dio? dio}) : _dio = dio ?? Dio();

  /// Busca conhecimento técnico sobre um tópico específico
  /// 
  /// Retorna lista de resultados relevantes de fontes técnicas
  Future<List<SearchResult>> searchTechnicalKnowledge({
    required String query,
    required String sector,
    int maxResults = 5,
  }) async {
    try {
      // Validar chave de API
      if (_apiKey.contains('your_')) {
        return _getFallbackResults(query, sector);
      }

      // Construir query com filtros técnicos
      final enhancedQuery = _buildEnhancedQuery(query, sector);

      // Chamar Google Custom Search API
      final response = await _dio.get(
        'https://www.googleapis.com/customsearch/v1',
        queryParameters: {
          'key': _apiKey,
          'cx': _searchEngineId,
          'q': enhancedQuery,
          'num': maxResults,
          'safe': 'off',
        },
      );

      return _processSearchResults(response.data);
    } on DioException catch (e) {
      // Retornar resultados fallback em caso de erro
      return _getFallbackResults(query, sector);
    }
  }

  /// Busca informações sobre um produto específico
  Future<Map<String, dynamic>> searchProductInfo({
    required String productName,
    required String brand,
    required String sector,
  }) async {
    try {
      final query = '$productName $brand polimento $sector';
      final results = await searchTechnicalKnowledge(
        query: query,
        sector: sector,
        maxResults: 3,
      );

      return {
        'productName': productName,
        'brand': brand,
        'sector': sector,
        'results': results,
        'timestamp': DateTime.now(),
      };
    } catch (e) {
      return {
        'error': 'Não foi possível buscar informações do produto',
        'productName': productName,
      };
    }
  }

  /// Busca recalls ou avisos de segurança
  Future<List<SearchResult>> searchSafetyAlerts({
    required String productName,
    required String sector,
  }) async {
    try {
      final query = '$productName recall segurança avisos $sector';
      return await searchTechnicalKnowledge(
        query: query,
        sector: sector,
        maxResults: 3,
      );
    } catch (e) {
      return [];
    }
  }

  /// Busca técnicas recentes de polimento
  Future<List<SearchResult>> searchLatestTechniques({
    required String sector,
    required String surfaceType,
  }) async {
    try {
      final query = 'técnicas polimento 2024 $sector $surfaceType';
      return await searchTechnicalKnowledge(
        query: query,
        sector: sector,
        maxResults: 5,
      );
    } catch (e) {
      return [];
    }
  }

  /// Constrói query otimizada com filtros técnicos
  String _buildEnhancedQuery(String query, String sector) {
    final brandFilter = technicalBrands.map((b) => 'site:$b.com').join(' OR ');
    final sectorKeywords = _getSectorKeywords(sector);

    return '$query $sectorKeywords ($brandFilter)';
  }

  /// Retorna keywords específicas por setor
  String _getSectorKeywords(String sector) {
    switch (sector.toLowerCase()) {
      case 'automotive':
        return 'verniz carro polimento detalhamento';
      case 'marine':
        return 'gel coat barco náutico polimento';
      case 'aerospace':
        return 'alumínio aeronáutico aviação polimento';
      case 'industrial':
        return 'metal industrial polimento inox';
      default:
        return 'polimento técnico';
    }
  }

  /// Processa resultados da busca
  List<SearchResult> _processSearchResults(Map<String, dynamic> response) {
    final results = <SearchResult>[];

    if (response['items'] is List) {
      for (final item in response['items']) {
        final source = _extractSource(item['link'] ?? '');
        final relevance = _calculateRelevance(item);

        results.add(SearchResult(
          title: item['title'] ?? 'Sem título',
          url: item['link'] ?? '',
          snippet: item['snippet'] ?? '',
          source: source,
          relevance: relevance,
        ));
      }
    }

    // Ordenar por relevância
    results.sort((a, b) => b.relevance.compareTo(a.relevance));

    return results;
  }

  /// Extrai a fonte (marca) da URL
  String _extractSource(String url) {
    for (final brand in technicalBrands) {
      if (url.toLowerCase().contains(brand.toLowerCase())) {
        return brand;
      }
    }

    // Extrair domínio
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '').split('.')[0];
    } catch (e) {
      return 'Desconhecido';
    }
  }

  /// Calcula relevância do resultado (0-1)
  double _calculateRelevance(Map<String, dynamic> item) {
    double relevance = 0.5; // Base

    // Aumentar se for de marca técnica conhecida
    final url = (item['link'] ?? '').toString().toLowerCase();
    for (final brand in technicalBrands) {
      if (url.contains(brand.toLowerCase())) {
        relevance += 0.3;
        break;
      }
    }

    // Aumentar se snippet é longo (mais informação)
    final snippet = (item['snippet'] ?? '').toString();
    if (snippet.length > 150) {
      relevance += 0.1;
    }

    return relevance.clamp(0.0, 1.0);
  }

  /// Retorna resultados fallback quando API não está disponível
  List<SearchResult> _getFallbackResults(String query, String sector) {
    return [
      SearchResult(
        title: 'Guia Técnico de Polimento - Rupes',
        url: 'https://www.rupes.com/pt/guias-tecnicos',
        snippet: 'Guia completo de polimento com recomendações de RPM e produtos',
        source: 'Rupes',
        relevance: 0.95,
      ),
      SearchResult(
        title: 'Manual de Produtos - Koch-Chemie',
        url: 'https://www.koch-chemie.com/pt/manuais',
        snippet: 'Manuais técnicos de compostos e pads para diferentes superfícies',
        source: 'Koch-Chemie',
        relevance: 0.90,
      ),
      SearchResult(
        title: 'Soluções de Polimento 3M',
        url: 'https://www.3m.com/pt/polimento',
        snippet: 'Produtos e técnicas de polimento profissional',
        source: '3M',
        relevance: 0.85,
      ),
    ];
  }

  /// Testa a conexão com Google Search API
  Future<bool> testConnection() async {
    try {
      if (_apiKey.contains('your_')) {
        return false;
      }

      final response = await _dio.get(
        'https://www.googleapis.com/customsearch/v1',
        queryParameters: {
          'key': _apiKey,
          'cx': _searchEngineId,
          'q': 'test',
          'num': 1,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
