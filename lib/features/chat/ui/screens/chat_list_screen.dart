// Fichier : lib/features/chat/ui/screens/chat_list_screen.dart
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  // F1.3.1: Liste conversations récentes (mockée pour l'instant)
  @override
  Widget build(BuildContext context) {
    // F1.8.2: État vide "Aucune conversation" sera ajouté plus tard.
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Conversations'), elevation: 0),
      body: const Center(child: Text('Liste des conversations (F1.3.1, F1.5)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('Nouvelle conversation (F1.3.1)'),
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
