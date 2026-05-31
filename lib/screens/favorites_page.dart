import 'package:flutter/material.dart';
import '../utils/luxury_theme.dart';
import '../services/favorites_service.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset>  _slide;

  final _favs = FavoritesService.instance;
  final _auth = AuthService.instance;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _favs.addListener(_onChanged);
    _auth.addListener(_onChanged);
    if (_auth.isLoggedIn) {
      _favs.load().then((_) => _ctrl.forward());
    } else {
      _ctrl.forward();
    }
  }

  void _onChanged() { if (mounted) setState(() {}); }

  @override
  void dispose() {
    _favs.removeListener(_onChanged);
    _auth.removeListener(_onChanged);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_auth.isLoggedIn) {
      return Scaffold(
        backgroundColor: LuxTheme.sand,
        body: SafeArea(child: Center(child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [LuxTheme.sandDark, LuxTheme.sand]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border_rounded, size: 36, color: LuxTheme.latte),
            ),
            const SizedBox(height: 20),
            const Text('Your Saved Places', style: LuxTheme.titleLg),
            const SizedBox(height: 8),
            Text('Sign in to save your favourite destinations.',
                style: LuxTheme.body, textAlign: TextAlign.center),
            const SizedBox(height: 28),
            SizedBox(width: 200, child: LuxButton(
              label: 'Sign In',
              icon: Icons.login_rounded,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginPage())),
            )),
          ]),
        ))),
      );
    }

    final favorites = _favs.favorites;

    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: SafeArea(child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: FadeSlideIn(
            fade: _fade, slide: _slide,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Saved Places', style: LuxTheme.displayMd),
                const SizedBox(height: 6),
                Text(
                  favorites.isEmpty
                      ? 'No saved places yet'
                      : '${favorites.length} place${favorites.length == 1 ? '' : 's'} saved',
                  style: LuxTheme.body,
                ),
                const SizedBox(height: 24),
                const GoldDivider(label: 'YOUR COLLECTION'),
              ]),
            ),
          )),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          favorites.isEmpty
              ? SliverFillRemaining(child: _EmptyState())
              : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, i) {
                  final fav = favorites[i];
                  return _FavCard(
                    name:     fav.wilayaName,
                    image:    fav.wilayaImage,
                    tag:      fav.category,
                    onRemove: () => _favs.remove(fav.wilayaName),
                  );
                },
                childCount: favorites.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      )),
    );
  }
}

// ── Fav Card — rating/reviews removed ────────────────────────
class _FavCard extends StatelessWidget {
  final String name, image, tag;
  final VoidCallback onRemove;
  const _FavCard({
    required this.name,
    required this.image,
    required this.tag,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: LuxTheme.cream,
      borderRadius: LuxTheme.radius20,
      boxShadow: LuxTheme.cardShadow,
    ),
    child: Row(children: [
      ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
        child: Image.asset(image,
          width: 100, height: 100, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 100, height: 100,
            decoration: const BoxDecoration(gradient: LuxTheme.terracottaGrad),
            child: const Icon(Icons.landscape_rounded,
                color: Colors.white54, size: 36),
          ),
        ),
      ),
      Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoldBadge(label: tag),
            const SizedBox(height: 8),
            Text(name, style: LuxTheme.titleMd),
          ],
        ),
      )),
      Padding(
        padding: const EdgeInsets.only(right: 14),
        child: PressScale(
          onTap: onRemove,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: LuxTheme.sand, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_rounded,
                color: LuxTheme.terracotta, size: 20),
          ),
        ),
      ),
    ]),
  );
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 90, height: 90,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [LuxTheme.sandDark, LuxTheme.sand]),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.favorite_border_rounded,
            size: 40, color: LuxTheme.latte),
      ),
      const SizedBox(height: 20),
      const Text('Nothing saved yet', style: LuxTheme.titleMd),
      const SizedBox(height: 8),
      Text('Tap ♥ on any destination to save it', style: LuxTheme.body),
    ],
  ));
}