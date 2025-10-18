// Fichier : lib/features/chat/ui/widgets/chat_bubble.dart

import 'package:flutter/material.dart';

// Définition de l'énumération pour le type d'émetteur
enum MessageSender { user, bot }

class ChatBubble extends StatelessWidget {
  final String message;
  final MessageSender sender;
  final String timestamp; // F1.5.4: Timestamps

  const ChatBubble({
    super.key,
    required this.message,
    required this.sender,
    this.timestamp = 'maintenant', // Mocké pour l'instant
  });

  @override
  Widget build(BuildContext context) {
    final isUser = sender == MessageSender.user;
    final theme = Theme.of(context);

    // F1.5.2: Alignement des bulles (droite pour user, gauche pour bot)
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              // F1.5.2: Styles des bulles (couleurs et forme)
              decoration: BoxDecoration(
                color: isUser
                    ? theme
                          .primaryColor // Couleur principale pour l'utilisateur
                    : theme.colorScheme.surface, // Couleur neutre pour le bot
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width *
                    0.75, // Max 75% de l'écran
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
            ),

            // Affichage du timestamp discret (F1.5.4)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0),
              child: Text(
                timestamp,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),

            // F1.5.8: Boutons feedback (👍/👎) sous la réponse bot
            if (!isUser) _buildFeedbackButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.thumb_up_outlined, size: 16),
            color: Theme.of(context).colorScheme.secondary, // Vert ivoirien
            onPressed: () => print('Feedback Positif (👍)'),
          ),
          IconButton(
            icon: const Icon(Icons.thumb_down_outlined, size: 16),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            onPressed: () => print('Feedback Négatif (👎)'),
          ),
        ],
      ),
    );
  }
}
