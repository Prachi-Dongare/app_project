import 'package:flutter/material.dart';
import 'login_page.dart';
import 'course_page.dart';
import 'profile_page.dart'; // Import the profile page

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('E-Education App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
            SizedBox(height: 10),

            // Welcome text
            Text(
              'Welcome',
              style: TextStyle(fontSize: 20, color: Colors.black87),
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
                backgroundColor: Colors.blue[700],
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
                backgroundColor: Colors.blue[700],
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
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                minimumSize: Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
