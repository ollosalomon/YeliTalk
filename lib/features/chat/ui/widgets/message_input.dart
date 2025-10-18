// Fichier : lib/features/chat/ui/widgets/message_input.dart

import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    // F1.5.6: Logique d'envoi mockée (affichée dans la console)
    print('Message envoyé: ${_controller.text}');

    // Ici, le code réel appellerait la Cloud Function 'sendMessage' (Étape 2) [cite: 941]

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          // F1.5.5: Champ de texte multiline avec auto-resize
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 5, // Limite le redimensionnement
              minLines: 1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Écrivez votre message',
                fillColor: theme.colorScheme.surface,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),

          // F1.5.6: Bouton d'envoi
          FloatingActionButton.small(
            heroTag: "send_button", // Évite les conflits de HeroTag
            onPressed: _sendMessage,
            backgroundColor: theme.primaryColor,
            elevation: 0,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
