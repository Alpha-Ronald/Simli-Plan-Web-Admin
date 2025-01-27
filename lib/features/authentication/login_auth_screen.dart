import 'dart:ui';

import 'package:flutter/material.dart';

import '../../services/firebase/admin_auth.dart';

class LoginAuthPage extends StatefulWidget {
  const LoginAuthPage({Key? key}) : super(key: key);

  @override
  State<LoginAuthPage> createState() => _LoginAuthPageState();
}

class _LoginAuthPageState extends State<LoginAuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AdminAuthService _authService = AdminAuthService();

  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Perform login
      await _authService.loginAdmin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Navigate to admin dashboard on success
      Navigator.pushReplacementNamed(context, '/DashboardScreen');
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF673AB7), // #673AB7
                  Color(0xFF0B00E4), // #0B00E4
                  Color(0xFFFF725E), // #FF725E
                ],
                stops: [0.25, 0.57, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 40, // Adjust top spacing as needed
            left: 20, // Adjust right spacing as needed
            child: Text(
              'SimpliPlan Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
          // Centered glass morphism box
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 450,//MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      // Email field
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Password field
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      // Login button
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text('Login',style: TextStyle(fontSize: 20,)),
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
}