/// Configuração de variáveis de ambiente para ClickforShine
/// 
/// Este arquivo gerencia todas as chaves de API de forma centralizada.
/// As chaves são carregadas de um arquivo .env na raiz do projeto.
/// 
/// Uso:
/// ```dart
/// final config = EnvConfig();
/// final azureKey = config.azureVisionKey;
/// final openaiKey = config.openaiApiKey;
/// ```

class EnvConfig {
  // ========================================================================
  // FIREBASE
  // ========================================================================
  
  /// Chave de API do Firebase
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'your_firebase_api_key_here',
  );

  /// Domínio de autenticação do Firebase
  static const String firebaseAuthDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
    defaultValue: 'your_project.firebaseapp.com',
  );

  /// ID do projeto Firebase
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'your_project_id',
  );

  /// Bucket de armazenamento do Firebase
  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: 'your_project.appspot.com',
  );

  /// ID do remetente de mensagens do Firebase
  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: 'your_messaging_sender_id',
  );

  /// ID da aplicação no Firebase
  static const String firebaseAppId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: 'your_app_id',
  );

  // ========================================================================
  // MICROSOFT AZURE VISION
  // ========================================================================

  /// Chave de API do Microsoft Azure Vision
  /// 
  /// Usada para análise de superfícies com 99% de precisão.
  /// Obtém em: https://portal.azure.com → Computer Vision
  static const String azureVisionKey = String.fromEnvironment(
    'AZURE_VISION_KEY',
    defaultValue: 'your_azure_vision_key_here',
  );

  /// Endpoint do Microsoft Azure Vision
  /// 
  /// Formato: https://your-region.api.cognitive.microsoft.com/
  static const String azureVisionEndpoint = String.fromEnvironment(
    'AZURE_VISION_ENDPOINT',
    defaultValue: 'https://eastus.api.cognitive.microsoft.com/',
  );

  /// Região do Azure Vision (ex: eastus, westeurope)
  static const String azureVisionRegion = String.fromEnvironment(
    'AZURE_VISION_REGION',
    defaultValue: 'eastus',
  );

  // ========================================================================
  // OPENAI GPT-4
  // ========================================================================

  /// Chave de API da OpenAI
  /// 
  /// Usada para geração de laudos técnicos profissionais.
  /// Obtém em: https://platform.openai.com/api-keys
  static const String openaiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: 'sk-your_openai_key_here',
  );

  /// Modelo GPT a ser utilizado
  /// 
  /// Opções: gpt-4, gpt-4-turbo, gpt-3.5-turbo
  static const String openaiModel = String.fromEnvironment(
    'OPENAI_MODEL',
    defaultValue: 'gpt-4',
  );

  /// ID da organização OpenAI (opcional)
  static const String openaiOrganizationId = String.fromEnvironment(
    'OPENAI_ORGANIZATION_ID',
    defaultValue: '',
  );

  // ========================================================================
  // GOOGLE CLOUD
  // ========================================================================

  /// ID do projeto Google Cloud
  static const String googleCloudProjectId = String.fromEnvironment(
    'GOOGLE_CLOUD_PROJECT_ID',
    defaultValue: 'your_google_cloud_project',
  );

  /// Chave de API do Google Cloud
  static const String googleCloudApiKey = String.fromEnvironment(
    'GOOGLE_CLOUD_API_KEY',
    defaultValue: 'your_google_cloud_api_key',
  );

  // ========================================================================
  // AMBIENTE E CONFIGURAÇÕES
  // ========================================================================

  /// Ambiente da aplicação (development, staging, production)
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Nome da aplicação
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'ClickforShine',
  );

  /// Versão da aplicação
  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  /// Modo debug ativado
  static const String debugMode = String.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: 'true',
  );

  // ========================================================================
  // MÉTODOS AUXILIARES
  // ========================================================================

  /// Verifica se todas as chaves obrigatórias estão configuradas
  static bool validateRequiredKeys() {
    final requiredKeys = [
      firebaseApiKey,
      firebaseProjectId,
      azureVisionKey,
      openaiApiKey,
    ];

    for (final key in requiredKeys) {
      if (key.contains('your_') || key.isEmpty) {
        return false;
      }
    }

    return true;
  }

  /// Retorna uma lista de chaves não configuradas
  static List<String> getMissingKeys() {
    final missing = <String>[];

    if (firebaseApiKey.contains('your_')) missing.add('FIREBASE_API_KEY');
    if (firebaseProjectId.contains('your_')) missing.add('FIREBASE_PROJECT_ID');
    if (azureVisionKey.contains('your_')) missing.add('AZURE_VISION_KEY');
    if (openaiApiKey.contains('your_')) missing.add('OPENAI_API_KEY');

    return missing;
  }

  /// Retorna true se está em modo de desenvolvimento
  static bool isDevelopment() => environment == 'development';

  /// Retorna true se está em modo de produção
  static bool isProduction() => environment == 'production';

  /// Retorna true se debug está ativado
  static bool isDebugEnabled() => debugMode == 'true';
}
