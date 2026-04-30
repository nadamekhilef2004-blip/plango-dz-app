import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isHoveringMainButton = false;
  bool _isHoveringGoogle = false;
  bool _isHoveringApple = false;

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  final TextEditingController _registerFirstNameController =
      TextEditingController();
  final TextEditingController _registerLastNameController =
      TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerConfirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.asset(
      'assets/videos/montains2.mp4',
    );
    await _videoController.initialize();
    await _videoController.setLooping(true);
    await _videoController.setVolume(0.0);
    await _videoController.play();
    setState(() => _isVideoInitialized = true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerFirstNameController.dispose();
    _registerLastNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: null,
        ),
        body: Stack(
          children: [
            if (_isVideoInitialized)
              SizedBox.expand(child: VideoPlayer(_videoController))
            else
              Container(color: const Color(0xFF2E7D32)),
            Container(color: Colors.black.withOpacity(0.4)),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _isLoginMode ? 'Sign In' : 'Create Account',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Container(
                          width: 420,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isLoginMode) ...[
                                const SizedBox(height: 5),
                                _buildGlassTextField(
                                  hint: "Email",
                                  controller: _loginEmailController,
                                  obscure: false,
                                ),
                                const SizedBox(height: 12),
                                _buildGlassTextField(
                                  hint: "Password",
                                  controller: _loginPasswordController,
                                  obscure: true,
                                  isPassword: true,
                                ),
                                const SizedBox(height: 24),
                                _buildHoverButton(
                                  onPressed: _handleLogin,
                                  text: "Sign In",
                                  isHovering: _isHoveringMainButton,
                                  onEnter: () => setState(
                                    () => _isHoveringMainButton = true,
                                  ),
                                  onExit: () => setState(
                                    () => _isHoveringMainButton = false,
                                  ),
                                ),
                              ],
                              if (!_isLoginMode) ...[
                                const SizedBox(height: 5),
                                _buildGlassTextField(
                                  hint: "First Name",
                                  controller: _registerFirstNameController,
                                  obscure: false,
                                ),
                                const SizedBox(height: 12),
                                _buildGlassTextField(
                                  hint: "Last Name",
                                  controller: _registerLastNameController,
                                  obscure: false,
                                ),
                                const SizedBox(height: 12),
                                _buildGlassTextField(
                                  hint: "Email",
                                  controller: _registerEmailController,
                                  obscure: false,
                                ),
                                const SizedBox(height: 12),
                                _buildGlassTextField(
                                  hint: "Password",
                                  controller: _registerPasswordController,
                                  obscure: true,
                                  isPassword: true,
                                ),
                                const SizedBox(height: 12),
                                _buildGlassTextField(
                                  hint: "Confirm Password",
                                  controller:
                                      _registerConfirmPasswordController,
                                  obscure: true,
                                  isConfirmPassword: true,
                                ),
                                const SizedBox(height: 24),
                                _buildHoverButton(
                                  onPressed: _handleRegister,
                                  text: "Create Account",
                                  isHovering: _isHoveringMainButton,
                                  onEnter: () => setState(
                                    () => _isHoveringMainButton = true,
                                  ),
                                  onExit: () => setState(
                                    () => _isHoveringMainButton = false,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isLoginMode
                                        ? "Don't have an account?"
                                        : "Already have an account?",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => setState(
                                      () => _isLoginMode = !_isLoginMode,
                                    ),
                                    child: Text(
                                      _isLoginMode
                                          ? "Create Account"
                                          : "Sign In",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSocialButton(
                                      icon: Icons.g_mobiledata,
                                      label: "Google",
                                      isHovering: _isHoveringGoogle,
                                      onEnter: () => setState(
                                        () => _isHoveringGoogle = true,
                                      ),
                                      onExit: () => setState(
                                        () => _isHoveringGoogle = false,
                                      ),
                                      onTap: () =>
                                          _showSocialSnackbar("Google"),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSocialButton(
                                      icon: Icons.apple,
                                      label: "Apple",
                                      isHovering: _isHoveringApple,
                                      onEnter: () => setState(
                                        () => _isHoveringApple = true,
                                      ),
                                      onExit: () => setState(
                                        () => _isHoveringApple = false,
                                      ),
                                      onTap: () => _showSocialSnackbar("Apple"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoverButton({
    required VoidCallback onPressed,
    required String text,
    required bool isHovering,
    required VoidCallback onEnter,
    required VoidCallback onExit,
  }) {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isHovering
                ? const Color(0xFF1B5E20)
                : const Color(0xFF2E7D32),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: isHovering ? 8 : 2,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required bool isHovering,
    required VoidCallback onEnter,
    required VoidCallback onExit,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isHovering
                ? Colors.white.withOpacity(0.25)
                : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    bool showSuffix = isPassword || isConfirmPassword;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure
                ? (isPassword
                      ? _obscurePassword
                      : (isConfirmPassword ? _obscureConfirmPassword : false))
                : false,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 0,
              ),
              suffixIcon: showSuffix
                  ? IconButton(
                      icon: Icon(
                        (isPassword
                                ? _obscurePassword
                                : _obscureConfirmPassword)
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() {
                        if (isPassword) {
                          _obscurePassword = !_obscurePassword;
                        } else if (isConfirmPassword)
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                      }),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter email and password");
      return;
    }
    // Simulation de connexion réussie
    if (email == "test@example.com" && password == "password") {
      // Retourne un Map avec le nom de l'utilisateur
      Navigator.pop(context, {'success': true, 'name': 'Test User'});
    } else {
      _showSnackBar(
        "Invalid email or password. Try: test@example.com / password",
      );
    }
  }

  void _handleRegister() {
    FocusScope.of(context).unfocus();
    final firstName = _registerFirstNameController.text.trim();
    final lastName = _registerLastNameController.text.trim();
    final email = _registerEmailController.text.trim();
    final password = _registerPasswordController.text.trim();
    final confirm = _registerConfirmPasswordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showSnackBar("Please fill all fields");
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBar("Please enter a valid email");
      return;
    }
    if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters");
      return;
    }
    if (password != confirm) {
      _showSnackBar("Passwords do not match");
      return;
    }
    final fullName = "$firstName $lastName";
    Navigator.pop(context, {'success': true, 'name': fullName});
  }

  void _showSocialSnackbar(String provider) {
    _showSnackBar("$provider sign in coming soon", isError: false);
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
