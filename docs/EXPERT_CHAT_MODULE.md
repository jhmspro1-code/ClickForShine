# Expert Shine Chat - Módulo de IA Conversacional

## 🎯 Visão Geral

**Expert Shine Chat** é um módulo de IA conversacional que transforma o ClickforShine em uma plataforma de consultoria técnica em tempo real.

### Características Principais

- ✅ **Context Awareness**: Acesso imediato aos metadados da última análise
- ✅ **Múltiplos Motores**: OpenAI (GPT-4o) + Microsoft Azure + Google Search
- ✅ **Streaming**: Respostas aparecem em tempo real
- ✅ **Personalidade**: Master Detailer internacional
- ✅ **Design Premium**: Dark mode com dourado e cinza grafite

## 🧠 Arquitetura

```
┌─────────────────────────────────────────┐
│     ExpertChatWidget (UI)               │
│  - Balões de conversa                   │
│  - Context awareness visual             │
│  - Input com validação                  │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│   ExpertChatDatasource (Lógica)         │
│  - Streaming de respostas                │
│  - Integração com OpenAI GPT-4o         │
│  - Suporte técnico Azure                │
└────────────────┬────────────────────────┘
                 │
        ┌────────┼────────┐
        │        │        │
        ▼        ▼        ▼
    OpenAI   Azure     Google
    GPT-4o   Vision    Search
```

## 📊 Fluxo de Conversa

```
1. Usuário faz pergunta
   ↓
2. ExpertChatWidget captura mensagem
   ↓
3. ExpertChatDatasource recebe contexto técnico
   ↓
4. Constrói system prompt com:
   - Personalidade Master Detailer
   - Metadados da análise anterior
   - Histórico de conversa
   ↓
5. Envia para OpenAI GPT-4o com streaming
   ↓
6. Respostas aparecem em tempo real
   ↓
7. Destaca recomendações cruciais em dourado
```

## 💻 Implementação

### 1. Datasource de Chat

```dart
// lib/data/datasources/expert_chat_datasource.dart

class ExpertChatDatasource {
  // Streaming de resposta
  Stream<String> chatWithStreaming({
    required String userMessage,
    required AnalysisContext? context,
    required List<ChatMessage> messageHistory,
  })

  // Resposta completa
  Future<String> generateAnalysisResponse({
    required String userMessage,
    required AnalysisContext context,
  })

  // Suporte técnico Azure
  Future<String> generateAzureTechnicalSupport({
    required String question,
    required String surfaceType,
    required String sector,
  })
}
```

### 2. Widget de Chat

```dart
// lib/presentation/widgets/expert_chat_widget.dart

class ExpertChatWidget extends StatefulWidget {
  final AnalysisContext? analysisContext;
  final Function(String message) onMessageSent;
  final Function(Stream<String> stream) onStreamResponse;
}
```

### 3. Entidades de Chat

```dart
// lib/domain/entities/chat_context.dart

class AnalysisContext {
  // Metadados da análise
  final String surfaceType;
  final List<String> defects;
  final double hardnessScore;
  final double damageLevel;
  final double aggressivenessScore;
  final String rpmRange;
  final String padType;
  final String compoundType;
  // ... mais campos
}

class ChatMessage {
  final String messageId;
  final String content;
  final String role; // 'user', 'assistant', 'system'
  final DateTime timestamp;
  final bool isStreaming;
  final AnalysisContext? context;
  final String? knowledgeSource;
  final double? responseConfidence;
}
```

## 🎓 Exemplos de Uso

### Exemplo 1: Chat Básico

```dart
final chatDS = ExpertChatDatasource();
final context = AnalysisContext(
  surfaceType: 'Clear Coat',
  defects: ['Swirls', 'Hologram'],
  hardnessScore: 5.0,
  damageLevel: 3.0,
  aggressivenessScore: 3.2,
  rpmRange: '1200-1600 RPM',
  padType: 'Espuma Fina',
  compoundType: 'Refino Suave',
  sector: 'automotive',
  // ... outros campos
);

// Streaming
final stream = chatDS.chatWithStreaming(
  userMessage: 'Por que você sugeriu 1500 RPM?',
  context: context,
  messageHistory: [],
);

stream.listen((chunk) {
  print(chunk); // Texto aparecendo em tempo real
});
```

### Exemplo 2: Resposta Completa

```dart
final response = await chatDS.generateAnalysisResponse(
  userMessage: 'Quais são os riscos de usar RPM mais alto?',
  context: context,
);

print(response);
// Resposta técnica detalhada com base no contexto
```

### Exemplo 3: Suporte Técnico Azure

```dart
final azureResponse = await chatDS.generateAzureTechnicalSupport(
  question: 'Qual composto usar para Gel Coat náutico?',
  surfaceType: 'Gel Coat ISO',
  sector: 'marine',
);
```

## 🎨 Design Premium

### Paleta de Cores

| Elemento | Cor | Hex |
|----------|-----|-----|
| Fundo | Preto Profundo | #000000 |
| Cards | Cinza Grafite | #1A1A1A |
| Destaque | Dourado Champagne | #D4AF37 |
| Usuário | Azul Cobalto | #2E5EAA |

### Tipografia

- **Fonte**: Montserrat (Google Fonts)
- **Recomendações Cruciais**: Dourado, bold
- **Avisos**: Dourado, bold
- **Texto Normal**: Branco, regular

### Balões de Conversa

```
┌─────────────────────────────┐
│ 🤖 Master Detailer          │
│                             │
│ Para este verniz cerâmico,  │
│ 1500 RPM é ideal porque:    │
│ • Dureza 9/10 (muito rígido)│
│ • RPM alto = superaquecimento│
│ • Seu setup oferece corte    │
│   eficiente sem risco       │
│                             │
│ Fonte: Rupes               │
│ Confiança: 95%             │
└─────────────────────────────┘
```

## 🔐 Configuração de Chaves

```env
# OpenAI GPT-4o
OPENAI_API_KEY=sk-your_key_here
OPENAI_MODEL=gpt-4o

# Microsoft Azure
AZURE_VISION_KEY=your_key_here
AZURE_VISION_ENDPOINT=https://your-region.api.cognitive.microsoft.com/

# Google Search
GOOGLE_CLOUD_API_KEY=your_key_here
GOOGLE_CLOUD_PROJECT_ID=your_project_id
```

## 💬 Personalidade do Chat

### Sistema Prompt

O chat é configurado como um **Master Detailer Internacional** com:

- **Experiência**: 20+ anos em polimento profissional
- **Conhecimento**: Rupes, Koch-Chemie, 3M, Meguiar's, Gyeon, Carpro, Sonax
- **Foco**: Segurança e preservação de superfícies
- **Linguagem**: Português técnico, direto e educado
- **Justificativa**: Sempre baseada em argumentos científicos

### Exemplos de Respostas

**Pergunta**: "Por que você sugeriu 1500 RPM?"

**Resposta**:
```
Para este verniz cerâmico BMW, 1500 RPM é ideal porque:

• Verniz cerâmico = dureza 9/10 (muito rígido)
• RPM mais alto causaria superaquecimento e dano irreversível
• 1500 RPM com espuma média oferece corte eficiente sem risco
• Sua análise detectou riscos profundos (dano 6/10), então precisamos de agressividade controlada

⚠️ AVISO: Não ultrapasse 1800 RPM neste verniz

Fonte: Rupes Technical Manual
Confiança: 97%
```

## 🚀 Recursos Avançados

### 1. Context Awareness

O chat tem acesso automático a:
- Tipo de superfície e marca/modelo
- Defeitos detectados (99% precisão)
- Dureza e nível de dano
- Setup recomendado
- Setor especializado
- Índice de segurança

### 2. Streaming em Tempo Real

Respostas aparecem caractere por caractere, criando sensação de:
- Resposta instantânea
- Interatividade premium
- Engajamento do usuário

### 3. Múltiplos Motores

- **OpenAI GPT-4o**: Conversação fluida e técnica
- **Microsoft Azure**: Suporte técnico de materiais específicos
- **Google Search**: Base de conhecimento em tempo real

### 4. Fonte de Conhecimento

Cada resposta inclui:
- Fonte (Rupes, Koch-Chemie, etc)
- Confiança (0-100%)
- Avisos de segurança

## 📈 Casos de Uso

### 1. Justificativa Técnica

**Profissional para Cliente**:
"Veja, o sistema indica que este Gel Coat exige 3 etapas de corte devido à oxidação detectada. Isso garante resultado profissional sem danificar a embarcação."

### 2. Educação Técnica

**Aprendiz para Master**:
"Por que o Gel Coat náutico é mais duro que verniz automotivo?"

Resposta com base técnica sólida.

### 3. Troubleshooting

**Profissional em Campo**:
"Estou tendo dificuldade com este verniz cerâmico. O que fazer?"

Resposta com alternativas seguras.

## 🧪 Testar o Chat

### 1. Validar Chaves

```dart
final chatDS = ExpertChatDatasource();
final isConnected = await chatDS.testConnection();
print('Chat conectado: $isConnected');
```

### 2. Teste de Streaming

```dart
final stream = chatDS.chatWithStreaming(
  userMessage: 'Teste de streaming',
  context: null,
  messageHistory: [],
);

stream.listen((chunk) {
  print('Chunk: $chunk');
});
```

### 3. Teste com Contexto

```dart
final context = AnalysisContext(
  // ... preencher campos
);

final stream = chatDS.chatWithStreaming(
  userMessage: 'Por que este setup?',
  context: context,
  messageHistory: [],
);
```

## 💰 Custos

| Serviço | Volume | Custo |
|---------|--------|-------|
| OpenAI GPT-4o | 1000 mensagens | $30-50/mês |
| Azure Vision | Suporte técnico | $5-10/mês |
| Google Search | Buscas | $0-10/mês |
| **Total** | | **$35-70/mês** |

## 🔄 Próximos Passos

1. Integrar com Firestore para persistência de chat
2. Adicionar histórico de conversas por usuário
3. Implementar feedback de qualidade (👍👎)
4. Adicionar suporte a múltiplos idiomas
5. Integrar com WhatsApp/Telegram para consultoria remota

## 📚 Referências

- [OpenAI API Streaming](https://platform.openai.com/docs/api-reference/chat/create)
- [Azure Cognitive Services](https://learn.microsoft.com/en-us/azure/ai-services/)
- [Google Custom Search API](https://developers.google.com/custom-search)

---

**Expert Shine Chat: Consultoria técnica de polimento em tempo real**
