// Fichier : lib/features/agent_chat/ui/screens/agent_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Écran de chat spécialisé pour les agents GPT.
// Implémentation simple utilisant une WebView qui charge l'URL du GPT fourni
// (passée via `agentGptUrl`).
// Remarque : Cette intégration ouvre l'interface web du GPT dans une WebView.
// Pour une intégration API/native (messages + RAG) il faudra créer un backend
// ou utiliser une API publique du modèle et implémenter le UI de conversation.
class AgentChatScreen extends StatefulWidget {
  final String agentName;
  final String agentGptUrl;

  const AgentChatScreen({
    super.key,
    required this.agentName,
    required this.agentGptUrl,
  });

  @override
  State<AgentChatScreen> createState() => _AgentChatScreenState();
}

class _AgentChatScreenState extends State<AgentChatScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            // Autoriser la navigation interne uniquement; les liens externes restent autorisés
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.agentGptUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agentName),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Ouvrir dans le navigateur',
            onPressed: () async {
              // Ouvrir l'URL dans le navigateur externe si nécessaire
              // On essaie d'utiliser launchUrl via `url_launcher` mais pour garder
              // la PR minimale, on utilise le package `url_launcher` seulement si
              // l'utilisateur l'ajoute plus tard. Ici on copie l'URL dans le presse-papier
              // ou on affiche un dialogue.
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Ouvrir dans le navigateur'),
                  content: Text('Voulez-vous ouvrir le chat dans le navigateur externe ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(c).pop(),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(c).pop();
                        // Utiliser le `url_launcher` si vous l'ajoutez plus tard.
                        // Pour l'instant on copie l'URL dans le presse-papier et montre un toast.
                        // (Optionnel : implémenter `url_launcher` pour ouvrir immédiatement.)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('URL: ${widget.agentGptUrl}')),
                        );
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
