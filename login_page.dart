import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌆 Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/image_3.png', // your background image
              fit: BoxFit.cover,
            ),
          ),

          // Transparent overlay for better readability
          Container(
            color: Colors.black.withOpacity(0.7),
          ),

          // Main content
          SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 115, 182, 238)
                      .withOpacity(0.85),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashboardPage()),
                      );
                    },
                  ),
                  title: const Text(
                    "Login / Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                  bottom: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    indicatorColor: const Color.fromARGB(255, 218, 8, 190),
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: "Login"),
                      Tab(text: "Sign Up"),
                    ],
                  ),
                ),

                // =================== MAIN BODY ===================
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginTab(),
                    _buildSignupTab(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGIN TAB =================
  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Welcome Back!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 121, 203, 236),
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            decoration: _inputDecoration("Email", Icons.email_outlined),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextField(
            obscureText: _obscureTextLogin,
            decoration: _passwordDecoration(
              "Password",
              _obscureTextLogin,
              () {
                setState(() {
                  _obscureTextLogin = !_obscureTextLogin;
                });
              },
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 218, 8, 190),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SIGNUP TAB =================
  Widget _buildSignupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Create an Account",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 121, 203, 236),
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            decoration: _inputDecoration("Full Name", Icons.person),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: _inputDecoration("Email", Icons.email_outlined),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextField(
            obscureText: _obscureTextSignup,
            decoration: _passwordDecoration(
              "Password",
              _obscureTextSignup,
              () {
                setState(() {
                  _obscureTextSignup = !_obscureTextSignup;
                });
              },
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 218, 8, 190),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= DECORATIONS =================
  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 218, 8, 190)),
      filled: true,
      fillColor: Colors.black45,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color.fromARGB(255, 218, 8, 190)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide:
            const BorderSide(color: Color.fromARGB(255, 218, 8, 190), width: 2),
      ),
    );
  }

  InputDecoration _passwordDecoration(
      String hint, bool obscure, VoidCallback toggle) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: const Icon(Icons.lock_outline,
          color: Color.fromARGB(255, 218, 8, 190)),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: const Color.fromARGB(255, 218, 8, 190),
        ),
        onPressed: toggle,
      ),
      filled: true,
      fillColor: Colors.black45,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color.fromARGB(255, 218, 8, 190)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide:
            const BorderSide(color: Color.fromARGB(255, 218, 8, 190), width: 2),
      ),
    );
  }
}
