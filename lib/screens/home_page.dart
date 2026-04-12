import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/destination.dart';
import '../widgets/weather_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/modern_destination_card.dart';
import '../utils/theme.dart';
import 'trip_planner_page.dart';
import 'favorites_page.dart';
import 'destination_detail_page.dart';
import 'login_page.dart';
import 'ai_trip_planner.dart';
import 'map_navigation_page.dart';
import 'virtual_tour_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedRegion = 'All';
  int _selectedIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  
  final List<String> regions = ['All', 'Central', 'North East', 'Saharan Algeria'];
  
  final List<Destination> destinations = [
    Destination(name: 'Algiers', region: 'Central', imageUrl: 'assets/images/algiers.jpg', description: 'Capital city with a rich history. Visit the Casbah, Notre Dame d\'Afrique, and beautiful Mediterranean coast.'),
    Destination(name: 'Bordj Bou Arreridj', region: 'Central', imageUrl: 'assets/images/bordj.jpg', description: 'Known for its traditional crafts, mountainous landscapes, and authentic Algerian culture.'),
    Destination(name: 'Ain Sefra', region: 'Saharan Algeria', imageUrl: 'assets/images/ain_sefra.jpg', description: 'The Gateway to the Sahara, famous for its red sand dunes and unique architecture.'),
    Destination(name: 'Bou Saada', region: 'Saharan Algeria', imageUrl: 'assets/images/bou_saada.jpg', description: 'Oasis city known as City of Happiness, famous for its palm groves and traditional crafts.'),
    Destination(name: 'Constantine', region: 'North East', imageUrl: 'assets/images/constantine.jpg', description: 'City of Bridges, perched on dramatic cliffs with stunning Ottoman architecture.'),
    Destination(name: 'Annaba', region: 'North East', imageUrl: 'assets/images/annaba.jpg', description: 'Coastal city with beautiful beaches, Roman ruins at Hippo Regius, and vibrant culture.'),
    Destination(name: 'Tlemcen', region: 'Central', imageUrl: 'assets/images/tlemcen.jpg', description: 'City of Art and History with magnificent Islamic architecture and ancient ruins.'),
    Destination(name: 'Ghardaia', region: 'Saharan Algeria', imageUrl: 'assets/images/ghardaia.jpg', description: 'UNESCO World Heritage site with unique Mozabite architecture and culture.'),
  ];

  List<Destination> get filteredDestinations {
    if (selectedRegion == 'All') return destinations;
    return destinations.where((dest) => dest.region == selectedRegion).toList();
  }

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildHomeContent(),
      const AITripPlannerPage(),
      const FavoritesPage(),
      _buildExplorePage(),
      _buildProfilePage(),
    ]);
    _loadDestinations();
  }
  
  void _loadDestinations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load destinations: $e';
      });
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildExplorePage() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.headerGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, size: 80, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Explore Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: TextStyle(color: AppTheme.textHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.headerGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Icon(Icons.person, size: 50, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: TextStyle(color: AppTheme.textHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading destinations...');
    }
    
    if (_errorMessage != null) {
      return ErrorDisplay(
        message: _errorMessage!,
        onRetry: _loadDestinations,
      );
    }
    
    return CustomScrollView(
      slivers: [
        // Hero Header
        SliverToBoxAdapter(
          child: Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC1D3C6), Color(0xFFEBF2E8), Color(0xFFEBF2E8)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Text('🇩🇿', style: TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PlanGo Dz',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212423),
                              ),
                            ),
                            Text(
                              'Votre Guide de l\'Algérie',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF414836),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wb_sunny, color: Color(0xFF6C7D76)),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Algiers',
                                  style: TextStyle(color: Color(0xFF212423), fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '22°C • Sunny',
                                  style: TextStyle(color: Color(0xFF414836), fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Perfect for travel!',
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Filter Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore by Region',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212423),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: regions.length,
                    itemBuilder: (context, index) {
                      final region = regions[index];
                      final isSelected = selectedRegion == region;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(region),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedRegion = region;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Travel Guide Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Travel Guide',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212423),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildGuideCard(
                        icon: Icons.flight_takeoff,
                        title: 'Travel Tips',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGuideCard(
                        icon: Icons.museum,
                        title: 'Culture',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGuideCard(
                        icon: Icons.restaurant,
                        title: 'Cuisine',
                        color: AppTheme.accentColor,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // City Guide Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore Regions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212423),
                  ),
                ),
                const SizedBox(height: 12),
                _buildRegionCard(
                  title: 'Central Algeria',
                  subtitle: 'Algiers, Tlemcen, Blida',
                  color: AppTheme.primaryColor,
                  icon: Icons.location_city,
                  onTap: () => setState(() => selectedRegion = 'Central'),
                ),
                const SizedBox(height: 12),
                _buildRegionCard(
                  title: 'North East Algeria',
                  subtitle: 'Constantine, Annaba, Skikda',
                  color: AppTheme.secondaryColor,
                  icon: Icons.landscape,
                  onTap: () => setState(() => selectedRegion = 'North East'),
                ),
                const SizedBox(height: 12),
                _buildRegionCard(
                  title: 'Saharan Algeria',
                  subtitle: 'Ain Sefra, Bou Saada, Ghardaia',
                  color: AppTheme.accentColor,
                  icon: Icons.wb_sunny,
                  onTap: () => setState(() => selectedRegion = 'Saharan Algeria'),
                ),
              ],
            ),
          ),
        ),
        
        // Featured Destinations
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedRegion == 'All' ? 'Featured Destinations' : 'Destinations in $selectedRegion',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212423),
                  ),
                ),
                if (selectedRegion != 'All')
                  TextButton(
                    onPressed: () => setState(() => selectedRegion = 'All'),
                    child: Text(
                      'See All',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ModernDestinationCard(
                destination: filteredDestinations[index],
              ),
              childCount: filteredDestinations.length,
            ),
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('PlanGo Dz'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: AppTheme.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AITripPlannerPage()),
              );
            },
            tooltip: 'AI Trip Planner',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppTheme.textPrimary),
            onPressed: () {
              setState(() {
                _selectedIndex = 4;
              });
            },
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.textPrimary),
            onPressed: () {
              _showLogoutDialog();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textHint,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'AI Planner'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
