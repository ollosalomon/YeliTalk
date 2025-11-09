// Fichier : lib/features/home/ui/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:YeliTalk/features/chat/ui/screens/chat_list_screen.dart';
import 'package:YeliTalk/features/profile/ui/screens/profile_screen.dart';
// 1. IMPORT PROFESSIONNEL : Importation de l'écran dédié à l'agent
import 'package:YeliTalk/features/agent_chat/ui/screens/agent_chat_screen.dart';

// Constante pour l'URL du GPT Expert Immobilier (maintenue ici pour les données)
const String _kExpertImmobilierGptUrl =
    'https://chatgpt.com/g/g-68e8f03fa4dc8191995b8a15ce5301be-mclu-gpt-by-daniel-koffi';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MarketplaceContent(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Utilisation de SafeArea sur le corps pour la compatibilité avec la barre d'état
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        onTap: _onItemTapped,
      ),
    );
  }
}

// -----------------------------------------------------------------
// MarketplaceContent (Structure Column/Expanded restaurée)
// -----------------------------------------------------------------

class MarketplaceContent extends StatelessWidget {
  const MarketplaceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Partie fixe : titre, recherche et chips
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.only(
            top: 25,
            left: 16,
            right: 16,
            bottom: 10,
          ),
          child: Column(
            children: [
              // Le titre 'Marketplace' était centré dans votre code d'origine
              Center(
                child: Text(
                  'Marketplace',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Barre de recherche
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un service...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  // Padding vertical qui fonctionne pour éviter l'overflow
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Chips de catégorie
              _buildCategoryChips(),
            ],
          ),
        ),

        // Partie défilante : contenu (Catégories de services et Grille)
        Expanded(
          child: SingleChildScrollView(
            // Padding ajusté pour ne pas être redondant avec le padding du Container
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alignement à gauche
              children: [
                const SizedBox(
                  height: 20,
                ), // Espace entre les chips et le titre
                Text(
                  'Catégories de services',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                _buildServiceGrid(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Méthode extraite pour les chips
  Widget _buildCategoryChips() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Chip(label: Text('Toutes')),
          SizedBox(width: 8),
          Chip(label: Text('Droit Pénal')),
          SizedBox(width: 8),
          Chip(label: Text('Immobilier')),
          SizedBox(width: 8),
          Chip(label: Text('Santé')),
          SizedBox(width: 8),
          Chip(label: Text('Finance')),
        ],
      ),
    );
  }

  // F1.4.1 : Grille des cartes de service (Mise à jour pour inclure l'URL)
  Widget _buildServiceGrid(BuildContext context) {
    // Définition des services avec l'URL GPT associée
    final mockServices = [
      {
        'name': 'Assistant Juridique',
        'desc':
            'Aide avec les lois locales, le droit de la famille et les contrats.',
        'icon': Icons.gavel,
        'isNew': true,
        'url': null,
      },
      {
        'name': 'Expert Immobilier',
        'desc':
            'Conseils sur l\'achat, la vente et la location de biens en Côte d\'Ivoire.',
        'icon': Icons.location_city,
        'isNew': false,
        'url': _kExpertImmobilierGptUrl, // URL GPT pour la navigation
      },
      {
        'name': 'Coach en Productivité',
        'desc':
            'Stratégies pour optimiser votre temps et atteindre vos objectifs professionnels.',
        'icon': Icons.lightbulb_outline,
        'isNew': false,
        'url': null,
      },
      {
        'name': 'Guide de Voyage Local',
        'desc':
            'Planification d\'itinéraires personnalisés pour découvrir la région.',
        'icon': Icons.travel_explore,
        'isNew': true,
        'url': null,
      },
    ];

    return Column(
      // Utilisation du Column pour empiler les cartes verticalement
      children: mockServices
          .map(
            (service) => _buildServiceCard(
              context,
              service['name'] as String,
              service['desc'] as String,
              service['icon'] as IconData,
              service['isNew'] as bool,
              service['url'] as String?, // Passage de l'URL
            ),
          )
          .toList(),
    );
  }

  // F1.4.1 : Carte de service (Signature et logique de navigation mises à jour)
  Widget _buildServiceCard(
    BuildContext context,
    String name,
    String description,
    IconData icon,
    bool isNew,
    String? gptUrl, // Le nouvel argument
  ) {
    // F1.4.3: Action de navigation vers l'écran de chat de l'agent
    void onTapAction() {
      if (gptUrl != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AgentChatScreen(agentName: name, agentGptUrl: gptUrl),
          ),
        );
      } else {
        debugPrint('Service $name sélectionné. Pas de chat GPT associé.');
      }
    }

    return Card(
      elevation: 2,
      // Ajout d'une marge pour séparer les cartes
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: onTapAction, // Utilisation de la nouvelle fonction de navigation
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                child: Icon(icon, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        // F1.4.4: Badge "Nouveau"
                        if (isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'NOUVEAU',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
