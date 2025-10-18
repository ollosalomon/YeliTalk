import 'package:flutter/material.dart';
import 'package:YeliTalk/features/chat/ui/screens/chat_list_screen.dart';
import 'package:YeliTalk/features/profile/ui/screens/profile_screen.dart';

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
// MarketplaceContent corrigé (sans overflow)
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
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un service...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SingleChildScrollView(
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
              ),
            ],
          ),
        ),

        // Partie défilante : contenu
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Catégories de services',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
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

  Widget _buildServiceGrid(BuildContext context) {
    final mockServices = [
      {
        'name': 'Assistant Juridique',
        'desc':
            'Aide avec les lois locales, le droit de la famille et les contrats.',
        'icon': Icons.gavel,
        'isNew': true,
      },
      {
        'name': 'Expert Immobilier',
        'desc':
            'Conseils sur l\'achat, la vente et la location de biens en Côte d\'Ivoire.',
        'icon': Icons.location_city,
        'isNew': false,
      },
      {
        'name': 'Coach en Productivité',
        'desc':
            'Stratégies pour optimiser votre temps et atteindre vos objectifs professionnels.',
        'icon': Icons.lightbulb_outline,
        'isNew': false,
      },
      {
        'name': 'Guide de Voyage Local',
        'desc':
            'Planification d\'itinéraires personnalisés pour découvrir la région.',
        'icon': Icons.travel_explore,
        'isNew': true,
      },
    ];

    return Column(
      children: mockServices
          .map(
            (service) => _buildServiceCard(
              context,
              service['name'] as String,
              service['desc'] as String,
              service['icon'] as IconData,
              service['isNew'] as bool,
            ),
          )
          .toList(),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String name,
    String description,
    IconData icon,
    bool isNew,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () => debugPrint('Sélection du service : $name'),
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
