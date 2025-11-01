import 'package:flutter/material.dart';
import 'login_page.dart';
import 'course_page.dart';
import 'profile_page.dart'; // Import the profile page

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wrap with Stack to add background image
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/image_4.png', // new background image
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                Text(
                  'E-Education',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 121, 203, 236),
                  ),
                ),
                SizedBox(height: 10),

                // Welcome text
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 25,
                    color: const Color.fromARGB(221, 189, 216, 227),
                  ),
                ),
                SizedBox(height: 40),

                // Login / Signup button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  icon: Icon(Icons.login),
                  label: Text('Login / Signup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 218, 8, 190),
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                ),
                SizedBox(height: 20),

                // Courses button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CoursePage()),
                    );
                  },
                  icon: Icon(Icons.book),
                  label: Text('Courses'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 218, 8, 190),
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                ),
                SizedBox(height: 20),

                // Profile button (navigates to ProfilePage)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  icon: Icon(Icons.person),
                  label: Text('Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 218, 8, 190),
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
