import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_context.dart';

/// Widget de Chat Expert Shine com design premium dark mode
/// 
/// Características:
/// - Balões de conversa em cinza grafite
/// - Tipografia dourada para recomendações cruciais
/// - Streaming de respostas
/// - Context awareness (acesso a metadados da análise)
class ExpertChatWidget extends StatefulWidget {
  /// Contexto técnico da análise anterior
  final AnalysisContext? analysisContext;

  /// Callback quando mensagem é enviada
  final Function(String message) onMessageSent;

  /// Callback para stream de resposta
  final Function(Stream<String> stream) onStreamResponse;

  const ExpertChatWidget({
    Key? key,
    this.analysisContext,
    required this.onMessageSent,
    required this.onStreamResponse,
  }) : super(key: key);

  @override
  State<ExpertChatWidget> createState() => _ExpertChatWidgetState();
}

class _ExpertChatWidgetState extends State<ExpertChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    // Adicionar mensagem do usuário
    setState(() {
      _messages.add(ChatMessage(
        messageId: const Uuid().v4(),
        content: userMessage,
        role: 'user',
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    // Notificar callback
    widget.onMessageSent(userMessage);

    // Scroll para baixo
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header com contexto
        if (widget.analysisContext != null)
          _buildContextHeader(),

        // Histórico de mensagens
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),

        // Input de mensagem
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildContextHeader() {
    final context = widget.analysisContext!;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Cinza grafite
        border: Border.all(color: const Color(0xFFD4AF37), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFFD4AF37),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Contexto Técnico',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${context.surfaceType} • ${context.defects.join(', ')} • ${context.rpmRange}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUserMessage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Color(0xFF000000),
                size: 18,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF2E5EAA) // Azul cobalto para usuário
                    : const Color(0xFF1A1A1A), // Cinza grafite para IA
                border: Border.all(
                  color: isUser
                      ? const Color(0xFF2E5EAA)
                      : const Color(0xFF333333),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conteúdo da mensagem
                  _buildMessageContent(message, isUser),

                  // Fonte de conhecimento (para IA)
                  if (!isUser && message.knowledgeSource != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Fonte: ${message.knowledgeSource}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFFD4AF37),
                          fontSize: 10,
                        ),
                      ),
                    ),

                  // Confiança (para IA)
                  if (!isUser && message.responseConfidence != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Confiança: ${(message.responseConfidence! * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF2E5EAA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message, bool isUser) {
    // Destacar recomendações cruciais em dourado
    final content = message.content;
    final hasCriticalKeywords = content.contains('AVISO') ||
        content.contains('SEGURANÇA') ||
        content.contains('CRÍTICO') ||
        content.contains('RISCO');

    return Text(
      content,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: hasCriticalKeywords && !isUser
            ? const Color(0xFFD4AF37)
            : Colors.white,
        fontWeight: hasCriticalKeywords ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF333333),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: !_isLoading,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Faça uma pergunta técnica...',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF333333),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isLoading
                    ? Colors.grey
                    : const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF000000),
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Color(0xFF000000),
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
