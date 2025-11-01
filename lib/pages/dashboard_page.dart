import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for sign out
import 'course_page.dart';
import 'profile_page.dart'; // Import the profile page

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Sign out function
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // The AuthWrapper in main.dart will automatically handle
      // navigation back to LoginPage
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('E-Education App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white, // Added for better contrast
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile', // Added tooltip
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          // Added Sign Out button back
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out', // Added tooltip
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Title
            Text(
              'E-Education',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.amber[900],
              ),
            ),
            const SizedBox(height: 10),

            // Welcome text
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            const SizedBox(height: 40),

            // Courses button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CoursePage()),
                );
              },
              icon: const Icon(Icons.book),
              label: const Text('Courses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

