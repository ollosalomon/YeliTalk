// Fichier : lib/features/chat/ui/screens/chat_screen.dart

import 'package:flutter/material.dart';
// Import du composant bulle
import 'package:YeliTalk/features/chat/ui/widgets/chat_bubble.dart';
// Import du composant input (créé en 3.)
import 'package:YeliTalk/features/chat/ui/widgets/message_input.dart';

class ChatScreen extends StatelessWidget {
  final String serviceTitle; // Pour F1.5.1: Header avec nom du service
  final List<Map<String, dynamic>> mockMessages = const [
    {
      'text':
          'Bonjour! Pouvez-vous me donner quelques idées de repas pour le dîner?',
      'sender': MessageSender.user,
    },
    {
      'text':
          'Bien sûr! Je suis l\'agent GPT spécialisé en Cuisine Ivoirienne. J\'ai plusieurs suggestions. Voulez-vous quelque chose de léger ou de traditionnel?',
      'sender': MessageSender.bot,
    },
    {
      'text': 'Je voudrais quelque chose de léger, rapide à préparer.',
      'sender': MessageSender.user,
    },
  ];

  const ChatScreen({super.key, this.serviceTitle = 'Cuisine Ivoirienne GPT'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // F1.5.1: Header
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(serviceTitle, style: const TextStyle(fontSize: 18)),
            const Text(
              'Agent spécialisé',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          // F1.5.1: Menu contextuel
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Menu : effacer conversation, signaler, etc.
              print('Menu conversation ouvert');
            },
          ),
        ],
      ),

      // Le body contient les messages et l'input
      body: Column(
        children: <Widget>[
          // F1.5.2: Zone de messages
          Expanded(
            child: ListView.builder(
              reverse: true, // Pour que les derniers messages soient en bas
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: mockMessages.length,
              itemBuilder: (context, index) {
                final msg = mockMessages.reversed.toList()[index];
                return ChatBubble(
                  message: msg['text'] as String,
                  sender: msg['sender'] as MessageSender,
                  // Le timestamp est mocké pour l'instant
                  timestamp: '14:30',
                );
              },
            ),
          ),

          // F1.5.7: Indicateur "Bot est en train d'écrire..." (Mocké)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'L\'expert GPT est en train d\'écrire...',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ),
          ),

          // F1.5.5, F1.5.6: Zone de saisie (implémentée ci-dessous)
          const MessageInput(),
        ],
      ),
    );
  }
}
