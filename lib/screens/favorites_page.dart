import 'package:flutter/material.dart';
import '../utils/luxury_theme.dart';

// ═══════════════════════════════════════════════════════════════
//  FAVORITES PAGE  —  Luxury Edition
// ═══════════════════════════════════════════════════════════════
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset>  _slide;

  // Sample saved items — in a real app these come from local DB / API
  final List<Map<String, dynamic>> _saved = [
    {'name': 'Tamanrasset', 'image': 'assets/images/wilayas/tamanrasset.jpg', 'tag': 'Sahara',   'rating': 5.0, 'reviews': 341},
    {'name': 'Ghardaïa',   'image': 'assets/images/wilayas/ghardaia.jpg',    'tag': 'Culture',  'rating': 4.9, 'reviews': 289},
    {'name': 'Béjaïa',    'image': 'assets/images/wilayas/bejaia.jpg',       'tag': 'Beach',    'rating': 4.7, 'reviews': 203},
  ];

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: SafeArea(child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(child: FadeSlideIn(
            fade: _fade, slide: _slide,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Saved Places', style: LuxTheme.displayMd),
                const SizedBox(height: 6),
                Text('Your curated collection', style: LuxTheme.body),
                const SizedBox(height: 24),
                const GoldDivider(label: 'YOUR COLLECTION'),
              ]),
            ),
          )),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          _saved.isEmpty
              ? SliverFillRemaining(child: _EmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => FadeTransition(
                        opacity: CurvedAnimation(parent: _ctrl, curve: Interval((i * 0.1).clamp(0.0, 0.6), ((i * 0.1) + 0.5).clamp(0.0, 1.0), curve: Curves.easeOut)),
                        child: _FavCard(item: _saved[i], onRemove: () => setState(() => _saved.removeAt(i))),
                      ),
                      childCount: _saved.length,
                    ),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      )),
    );
  }
}

class _FavCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  const _FavCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20, boxShadow: LuxTheme.cardShadow),
    child: Row(children: [
      // Image
      ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
        child: Image.asset(item['image'], width: 100, height: 100, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(width: 100, height: 100,
            decoration: const BoxDecoration(gradient: LuxTheme.terracottaGrad),
            child: const Icon(Icons.landscape_rounded, color: Colors.white54, size: 36)),
        ),
      ),
      // Info
      Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          GoldBadge(label: item['tag']),
          const SizedBox(height: 8),
          Text(item['name'], style: LuxTheme.titleMd),
          const SizedBox(height: 6),
          StarRating(rating: (item['rating'] as num).toDouble(), reviews: item['reviews']),
        ]),
      )),
      // Remove button
      Padding(
        padding: const EdgeInsets.only(right: 14),
        child: PressScale(
          onTap: onRemove,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: LuxTheme.sand, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_rounded, color: LuxTheme.terracotta, size: 20),
          ),
        ),
      ),
    ]),
  );
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(
      width: 90, height: 90,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [LuxTheme.sandDark, LuxTheme.sand]),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.favorite_border_rounded, size: 40, color: LuxTheme.latte),
    ),
    const SizedBox(height: 20),
    const Text('Nothing saved yet', style: LuxTheme.titleMd),
    const SizedBox(height: 8),
    Text('Tap ♥ on any destination to save it', style: LuxTheme.body),
  ]));
}