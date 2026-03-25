import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../utils/theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Elegant Purple Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.purpleBanner,
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Branding
                    const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'TaskFlow Pro',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Secure Admin Access',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Auth Card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLogin ? 'Login' : 'Create Account',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Form Fields
                          _buildField(LucideIcons.mail, 'Work Email'),
                          const SizedBox(height: 16),
                          _buildField(LucideIcons.lock, 'Password', isPassword: true),
                          if (!isLogin) ...[
                            const SizedBox(height: 16),
                            _buildField(LucideIcons.user, 'Full Name'),
                          ],
                          
                          const SizedBox(height: 32),
                          
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/home');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                isLogin ? 'SIGN IN' : 'GET STARTED',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Toggle
                          Center(
                            child: TextButton(
                              onPressed: () => setState(() => isLogin = !isLogin),
                              child: Text(
                                isLogin 
                                  ? "Don't have an account? Sign Up" 
                                  : "Already have an account? Login",
                                style: GoogleFonts.outfit(color: AppTheme.primary),
                              ),
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
        ],
      ),
    );
  }

  Widget _buildField(IconData icon, String label, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          icon: Icon(icon, size: 20, color: AppTheme.textDim),
          labelText: label,
          labelStyle: GoogleFonts.outfit(color: AppTheme.textDim),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
