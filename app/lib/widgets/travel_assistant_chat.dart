import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class TravelAssistantChat extends StatefulWidget {
  final GeminiService geminiService;
  final VoidCallback onClose;

  const TravelAssistantChat({
    super.key,
    required this.geminiService,
    required this.onClose,
  });

  @override
  State<TravelAssistantChat> createState() => _TravelAssistantChatState();
}

class _TravelAssistantChatState extends State<TravelAssistantChat> {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addMessage(
      'Hello! I\'m your travel assistant for Boumerdes. I can help you discover local attractions, find accommodations, and plan your activities. What would you like to know?',
      false,
    );
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
    });
  }

  Future<void> _handleSubmit(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    _addMessage(text, true);

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await widget.geminiService.getTravelSuggestions(text);
      if (mounted) {
        _addMessage(response, false);
      }
    } catch (e) {
      if (mounted) {
        _addMessage('Sorry, I encountered an error. Please try again.', false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 350,
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.assistant),
                const SizedBox(width: 8),
                const Text(
                  'Travel Assistant',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: message.isUser
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: CircularProgressIndicator(),
              ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _handleSubmit,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmit(_textController.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
