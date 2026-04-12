import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌄 Image arrière-plan
          SizedBox.expand(
            child: Image.asset(
              "assets/images/algeria.jpg", 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2E7D32),
                  child: const Center(
                    child: Text(
                      'PlanGo Dz',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🌫 Carte centrale floue
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF5D4037), width: 1.5),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      _buildGlassTextField(
                        hint: "Email", 
                        obscure: false,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      _buildGlassTextField(
                        hint: "Password", 
                        obscure: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleLogin(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 104, 74, 74),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        child: const Text(
                          "Skip for now",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter email and password");
      return;
    }
    
    // Demo authentication
    if (email == "test@example.com" && password == "password") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      _showSnackBar("Invalid email or password. Try: test@example.com / password");
    }
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildGlassTextField({
    required String hint, 
    required bool obscure,
    required TextEditingController controller,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF5D4037), width: 1.2),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure ? _obscurePassword : false,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
              suffixIcon: obscure
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}