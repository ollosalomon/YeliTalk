import 'package:flutter/material.dart';
// Import des écrans de navigation
import 'package:YeliTalk/features/chat/ui/screens/chat_list_screen.dart';
import 'package:YeliTalk/features/profile/ui/screens/profile_screen.dart';
// IMPORTANT: Import de l'écran de Chat détaillé pour la navigation des cartes
import 'package:YeliTalk/features/chat/ui/screens/chat_screen.dart';

// ----------------------------------------------------------------------
// WIDGET PRINCIPAL : Gère la navigation par onglets (F1.3.1)
// ----------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const MarketplaceContent(), // Onglet 1
    const ChatListScreen(), // Onglet 2
    const ProfileScreen(), // Onglet 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Le body affiche le contenu de l'onglet sélectionné
      body: _widgetOptions.elementAt(_selectedIndex),

      // F1.3.1: Navigation par onglets inférieure
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        // Utilise la couleur primaire du thème (orange)
        selectedItemColor: theme.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ----------------------------------------------------------------------
// CONTENU DE L'ONGLET ACCUEIL / MARKETPLACE (F1.3.3 & F1.4)
// ----------------------------------------------------------------------
class MarketplaceContent extends StatelessWidget {
  const MarketplaceContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: <Widget>[
        // F1.3.3: SliverAppBar avec barre de recherche
        SliverAppBar(
          // Utilisation d'un Container stylisé pour simuler le champ de recherche
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un service...',
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ),
          floating: true, // La barre s'affiche lors du défilement
          pinned: false,
          toolbarHeight: 80.0,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),

        // Titre de la section (non scrollable)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Services Spécialisés GPT',
              style: theme.textTheme.titleLarge,
            ),
          ),
        ),

        // F1.4: Liste des services GPT sous forme de grille
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Deux colonnes (NFR1.3)
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.9,
            ),
            delegate: SliverChildListDelegate([
              // Cartes de services mockées
              const _ServiceCard(
                title: 'Droit Pénal',
                icon: Icons.gavel,
                color: Colors.red,
              ),
              const _ServiceCard(
                title: 'Immobilier',
                icon: Icons.home_work,
                color: Colors.blue,
              ),
              const _ServiceCard(
                title: 'Fiscalité',
                icon: Icons.account_balance,
                color: Colors.green,
              ),
              const _ServiceCard(
                title: 'Cuisine Ivoirienne',
                icon: Icons.local_dining,
                color: Color(0xFFE88A1A),
              ), // Utilisation de l'orange primaire
            ]),
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------------
// WIDGET PRIVÉ : Carte d'un Service (F1.4)
// ----------------------------------------------------------------------
class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _ServiceCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        // Navigation vers le ChatScreen au clic (F1.4)
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              // Passage du titre du service au ChatScreen
              builder: (_) => ChatScreen(serviceTitle: title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              const Text(
                'Parlez à notre expert GPT',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
