import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/luxury_theme.dart';
import '../services/auth_service.dart';
import '../services/trip_storage.dart';
import '../services/favorites_service.dart';
import 'login_page.dart';
import 'register_page.dart';

// ═══════════════════════════════════════════════════════════════
//  PROFILE PAGE
// ═══════════════════════════════════════════════════════════════
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {

  final _auth      = AuthService.instance;
  final _trips     = TripStorageService.instance;
  final _favorites = FavoritesService.instance;

  late final AnimationController _ctrl;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _auth.addListener(_onAuthChanged);
    _trips.addListener(_onDataChanged);
    _favorites.addListener(_onDataChanged);
    _ctrl.forward();
  }

  void _onAuthChanged() {
    if (!mounted) return;
    setState(() {});
    _ctrl.reset();
    _ctrl.forward();
  }

  void _onDataChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    _trips.removeListener(_onDataChanged);
    _favorites.removeListener(_onDataChanged);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: _auth.isLoggedIn ? _buildProfile() : _buildGuest(),
      ),
    );
  }

  // ── GUEST VIEW ──────────────────────────────────────────────
  Widget _buildGuest() {
    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
        child: Column(children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [LuxTheme.sandDark, LuxTheme.sand],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: LuxTheme.cardShadow,
            ),
            child: const Icon(Icons.person_outline_rounded,
                size: 48, color: LuxTheme.latte),
          ),
          const SizedBox(height: 20),
          const Text('Your Profile', style: LuxTheme.displayMd),
          const SizedBox(height: 8),
          Text(
            'Sign in or create an account to unlock\nyour full travel experience.',
            style: LuxTheme.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          const GoldDivider(label: 'GET STARTED'),
          const SizedBox(height: 28),
          _Feature(icon: Icons.luggage_rounded,      label: 'Save & manage your itineraries'),
          const SizedBox(height: 14),
          _Feature(icon: Icons.favorite_rounded,     label: 'Bookmark favourite destinations'),
          const SizedBox(height: 14),
          _Feature(icon: Icons.auto_awesome_rounded, label: 'Personalised AI trip planning'),
          const SizedBox(height: 14),
          _Feature(icon: Icons.share_rounded,        label: 'Share your journeys with friends'),
          const SizedBox(height: 36),
          SizedBox(width: double.infinity, child: LuxButton(
            label: 'Create Account',
            icon: Icons.person_add_rounded,
            onTap: () async {
              HapticFeedback.lightImpact();
              await Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const RegisterPage()));
            },
          )),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: LuxButton(
            label: 'Sign In',
            icon: Icons.login_rounded,
            outlined: true,
            onTap: () async {
              HapticFeedback.lightImpact();
              await Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          )),
          const SizedBox(height: 32),
        ]),
      )),
    );
  }

  // ── AUTHENTICATED PROFILE VIEW ───────────────────────────────
  Widget _buildProfile() {
    final user       = _auth.user!;
    final avatarHex  = user.avatarColor;
    final avatarColor = Color(int.parse('FF$avatarHex', radix: 16));
    final tripCount  = _trips.count;
    final favCount   = _favorites.count;

    return Scaffold(
      backgroundColor: LuxTheme.sand,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Container(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
            decoration: BoxDecoration(
              color: LuxTheme.cream,
              boxShadow: LuxTheme.cardShadow,
            ),
            child: Column(children: [
              Stack(alignment: Alignment.bottomRight, children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(
                      color: avatarColor.withOpacity(0.45),
                      blurRadius: 22,
                      offset: const Offset(0, 6),
                    )],
                  ),
                  child: Center(child: Text(
                    user.initials,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )),
                ),
                PressScale(
                  onTap: () => _showEditNameSheet(user.name),
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [LuxTheme.gold, LuxTheme.goldLight]),
                      shape: BoxShape.circle,
                      border: Border.all(color: LuxTheme.cream, width: 2),
                    ),
                    child: const Icon(Icons.edit_rounded, size: 13, color: Colors.white),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              Text(user.name,
                  style: LuxTheme.displayMd.copyWith(fontSize: 24),
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(user.email,
                  style: LuxTheme.body.copyWith(fontSize: 13),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [LuxTheme.gold, LuxTheme.goldLight]),
                  borderRadius: LuxTheme.radiusPill,
                ),
                child: Text(
                  'Member since ${DateFormat('MMMM yyyy').format(user.joinedAt)}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ]),
          )),

          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(children: [
              _StatBox(value: '$tripCount', label: 'Trips'),
              const SizedBox(width: 12),
              _StatBox(value: '$favCount', label: 'Saved'),
              const SizedBox(width: 12),
              _StatBox(value: '0', label: 'Reviews'),
            ]),
          )),

          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              const GoldDivider(label: 'ACCOUNT'),
              const SizedBox(height: 14),
              _SettingsGroup(items: [
                _SettingsTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Name',
                  value: user.name,
                  onTap: () => _showEditNameSheet(user.name),
                ),
                _SettingsTile(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email Address',
                  value: user.email,
                  onTap: () => _showEditEmailSheet(user.email),
                ),
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Change Password',
                  onTap: _showChangePasswordSheet,
                ),
              ]),



              const SizedBox(height: 22),
              const GoldDivider(label: 'SUPPORT'),
              const SizedBox(height: 14),
              _SettingsGroup(items: [
                _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & FAQ',
                    onTap: () {}),
                _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () {}),
                _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About PlanGo DZ',
                    value: 'v1.0.0',
                    onTap: () {}),
              ]),

              const SizedBox(height: 24),
              const GoldDivider(),
              const SizedBox(height: 20),

              PressScale(
                onTap: _confirmSignOut,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: LuxTheme.radius14,
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 20),
                    const SizedBox(width: 10),
                    Text('Sign Out',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade500)),
                  ]),
                ),
              ),

              const SizedBox(height: 36),
            ]),
          )),
        ],
      ),
    );
  }

  void _showEditNameSheet(String current) {
    HapticFeedback.lightImpact();
    final ctrl = TextEditingController(text: current);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSheet(
        title: 'Edit Name',
        controller: ctrl,
        hint: 'Your full name',
        icon: Icons.person_outline_rounded,
        textCapitalization: TextCapitalization.words,
        onSave: (val) async {
          if (val.trim().length >= 2) {
            await _auth.updateName(val);
            HapticFeedback.mediumImpact();
          }
        },
      ),
    );
  }

  void _showEditEmailSheet(String current) {
    HapticFeedback.lightImpact();
    final ctrl = TextEditingController(text: current);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSheet(
        title: 'Edit Email',
        controller: ctrl,
        hint: 'you@example.com',
        icon: Icons.mail_outline_rounded,
        keyboardType: TextInputType.emailAddress,
        onSave: (val) async {
          if (val.contains('@')) {
            await _auth.updateEmail(val);
            HapticFeedback.mediumImpact();
          }
        },
      ),
    );
  }

  void _showChangePasswordSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  Future<void> _confirmSignOut() async {
    HapticFeedback.mediumImpact();
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ConfirmSheet(
        title: 'Sign Out',
        body: 'Are you sure you want to sign out?',
        confirmLabel: 'Sign Out',
        confirmColor: Colors.red.shade400,
      ),
    );
    if (confirm == true) {
      await _auth.logout();
      HapticFeedback.lightImpact();
    }
  }
}

// ══════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ══════════════════════════════════════════════════════════════

class _Feature extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Feature({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [LuxTheme.gold, LuxTheme.goldLight]),
        borderRadius: LuxTheme.radius10,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
    const SizedBox(width: 14),
    Text(label, style: LuxTheme.titleMd.copyWith(fontSize: 14)),
  ]);
}

class _StatBox extends StatelessWidget {
  final String value, label;
  const _StatBox({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        color: LuxTheme.cream,
        borderRadius: LuxTheme.radius14,
        boxShadow: LuxTheme.cardShadow),
    child: Column(children: [
      Text(value, style: LuxTheme.displayMd.copyWith(
          fontSize: 28, color: LuxTheme.terracotta)),
      const SizedBox(height: 4),
      Text(label, style: LuxTheme.caption),
    ]),
  ));
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsTile> items;
  const _SettingsGroup({required this.items});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        color: LuxTheme.cream,
        borderRadius: LuxTheme.radius20,
        boxShadow: LuxTheme.cardShadow),
    child: Column(children: List.generate(items.length, (i) => Column(children: [
      items[i],
      if (i < items.length - 1)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, color: LuxTheme.sandDark),
        ),
    ]))),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  const _SettingsTile(
      {required this.icon, required this.label, this.value, required this.onTap});
  @override
  Widget build(BuildContext context) => PressScale(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
              color: LuxTheme.sand, borderRadius: LuxTheme.radius10),
          child: Icon(icon, size: 18, color: LuxTheme.terracotta),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(label,
            style: LuxTheme.titleMd.copyWith(fontSize: 14))),
        if (value != null) ...[
          Text(value!,
              style: LuxTheme.caption.copyWith(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(width: 6),
        ],
        const Icon(Icons.chevron_right_rounded, size: 18, color: LuxTheme.latte),
      ]),
    ),
  );
}

class _EditSheet extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final Future<void> Function(String) onSave;
  const _EditSheet({
    required this.title,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onSave,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20),
      child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: LuxTheme.sandDark,
                    borderRadius: LuxTheme.radiusPill))),
            const SizedBox(height: 20),
            Text(title, style: LuxTheme.titleLg),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              autofocus: true,
              style: const TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w500, color: LuxTheme.espresso),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: LuxTheme.latte),
                prefixIcon: Icon(icon, color: LuxTheme.latte, size: 20),
                filled: true, fillColor: LuxTheme.sand,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                enabledBorder: OutlineInputBorder(
                    borderRadius: LuxTheme.radius14,
                    borderSide: const BorderSide(color: LuxTheme.sandDark)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: LuxTheme.radius14,
                    borderSide: const BorderSide(
                        color: LuxTheme.gold, width: 1.8)),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: PressScale(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(color: LuxTheme.sand,
                      borderRadius: LuxTheme.radius14,
                      border: Border.all(color: LuxTheme.sandDark)),
                  child: const Center(child: Text('Cancel',
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w600, color: LuxTheme.mocha))),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(child: PressScale(
                onTap: () async {
                  await onSave(controller.text);
                  if (context.mounted) Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [LuxTheme.terracotta, LuxTheme.terracottaL]),
                      borderRadius: LuxTheme.radius14),
                  child: const Center(child: Text('Save',
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700, color: Colors.white))),
                ),
              )),
            ]),
          ]),
    ),
  );
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();
  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _current = TextEditingController();
  final _newPass = TextEditingController();
  final _confirm = TextEditingController();
  bool _ob1 = true, _ob2 = true, _ob3 = true;
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _newPass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20),
      child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: LuxTheme.sandDark,
                    borderRadius: LuxTheme.radiusPill))),
            const SizedBox(height: 20),
            const Text('Change Password', style: LuxTheme.titleLg),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.red.shade50,
                    borderRadius: LuxTheme.radius10),
                child: Text(_error!,
                    style: TextStyle(color: Colors.red.shade600, fontSize: 12)),
              ),
            ],
            const SizedBox(height: 16),
            _PF(ctrl: _current, hint: 'Current password',
                ob: _ob1, onToggle: () => setState(() => _ob1 = !_ob1)),
            const SizedBox(height: 10),
            _PF(ctrl: _newPass, hint: 'New password',
                ob: _ob2, onToggle: () => setState(() => _ob2 = !_ob2)),
            const SizedBox(height: 10),
            _PF(ctrl: _confirm, hint: 'Confirm new password',
                ob: _ob3, onToggle: () => setState(() => _ob3 = !_ob3)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: PressScale(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(color: LuxTheme.sand,
                      borderRadius: LuxTheme.radius14,
                      border: Border.all(color: LuxTheme.sandDark)),
                  child: const Center(child: Text('Cancel',
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w600, color: LuxTheme.mocha))),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(child: PressScale(
                onTap: () async {
                  if (_newPass.text.length < 6) {
                    setState(() => _error = 'New password too short (min 6 chars).');
                    return;
                  }
                  if (_newPass.text != _confirm.text) {
                    setState(() => _error = 'Passwords do not match.');
                    return;
                  }
                  final result = await AuthService.instance.updatePassword(
                    currentPassword: _current.text,
                    newPassword: _newPass.text,
                  );
                  if (!context.mounted) return;
                  if (result.ok) {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                  } else {
                    setState(() => _error = result.errorMessage);
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [LuxTheme.terracotta, LuxTheme.terracottaL]),
                      borderRadius: LuxTheme.radius14),
                  child: const Center(child: Text('Update',
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700, color: Colors.white))),
                ),
              )),
            ]),
          ]),
    ),
  );
}

class _PF extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final bool ob;
  final VoidCallback onToggle;
  const _PF({required this.ctrl, required this.hint,
    required this.ob, required this.onToggle});
  @override
  Widget build(BuildContext context) => TextField(
    controller: ctrl,
    obscureText: ob,
    style: const TextStyle(fontSize: 14, color: LuxTheme.espresso),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: LuxTheme.latte, fontSize: 13),
      prefixIcon: const Icon(Icons.lock_outline_rounded,
          color: LuxTheme.latte, size: 18),
      suffixIcon: PressScale(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Icon(ob ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: LuxTheme.latte, size: 18),
        ),
      ),
      filled: true, fillColor: LuxTheme.sand,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(borderRadius: LuxTheme.radius14,
          borderSide: const BorderSide(color: LuxTheme.sandDark)),
      focusedBorder: OutlineInputBorder(borderRadius: LuxTheme.radius14,
          borderSide: const BorderSide(color: LuxTheme.gold, width: 1.8)),
    ),
  );
}

class _ConfirmSheet extends StatelessWidget {
  final String title, body, confirmLabel;
  final Color confirmColor;
  const _ConfirmSheet({required this.title, required this.body,
    required this.confirmLabel, required this.confirmColor});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: LuxTheme.cream, borderRadius: LuxTheme.radius20),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 40, height: 4,
          decoration: BoxDecoration(color: LuxTheme.sandDark,
              borderRadius: LuxTheme.radiusPill)),
      const SizedBox(height: 24),
      Text(title, style: LuxTheme.titleLg),
      const SizedBox(height: 8),
      Text(body, style: LuxTheme.body, textAlign: TextAlign.center),
      const SizedBox(height: 28),
      Row(children: [
        Expanded(child: PressScale(
          onTap: () => Navigator.pop(context, false),
          child: Container(height: 50,
            decoration: BoxDecoration(color: LuxTheme.sand,
                borderRadius: LuxTheme.radius14,
                border: Border.all(color: LuxTheme.sandDark)),
            child: const Center(child: Text('Cancel',
                style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w600, color: LuxTheme.mocha))),
          ),
        )),
        const SizedBox(width: 12),
        Expanded(child: PressScale(
          onTap: () => Navigator.pop(context, true),
          child: Container(height: 50,
            decoration: BoxDecoration(
                color: confirmColor, borderRadius: LuxTheme.radius14),
            child: Center(child: Text(confirmLabel,
                style: const TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700, color: Colors.white))),
          ),
        )),
      ]),
    ]),
  );
}