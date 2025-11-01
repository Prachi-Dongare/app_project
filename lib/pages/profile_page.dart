import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              // Show confirmation dialog
              bool? confirmLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirmLogout == true) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          // No data state
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No user data found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Create user document if it doesn't exist
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .set({
                        'email': user.email,
                        'joinedAt': Timestamp.now(),
                        'coursesEnrolled': [],
                        'videosWatched': [],
                      });
                    },
                    child: const Text('Create Profile'),
                  ),
                ],
              ),
            );
          }

          // Get user data
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Section with gradient
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.deepPurple, Colors.deepPurple.shade300],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.deepPurple.shade100,
                          child: Text(
                            _getInitials(userData['name'] ?? userData['email']),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        userData['name'] ?? 'Student',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email
                      Text(
                        userData['email'] ?? user.email ?? 'No email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Statistics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.school,
                              title: 'Courses',
                              value: (userData['coursesEnrolled']?.length ?? 0)
                                  .toString(),
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.play_circle_outline,
                              title: 'Videos',
                              value: (userData['videosWatched']?.length ?? 0)
                                  .toString(),
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Account Information
                      const Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildInfoTile(
                        icon: Icons.email,
                        title: 'Email',
                        value: userData['email'] ?? 'No email',
                      ),
                      _buildInfoTile(
                        icon: Icons.calendar_today,
                        title: 'Member Since',
                        value: _formatDate(userData['joinedAt']),
                      ),
                      _buildInfoTile(
                        icon: Icons.verified_user,
                        title: 'Account Status',
                        value: user.emailVerified ? 'Verified' : 'Not Verified',
                        trailing: user.emailVerified
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : TextButton(
                          onPressed: () async {
                            await user.sendEmailVerification();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Verification email sent!'),
                              ),
                            );
                          },
                          child: const Text('Verify'),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Edit Profile Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                  currentName: userData['name'] ?? '',
                                  currentEmail: userData['email'] ?? '',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper: Get initials from name/email
  String _getInitials(String text) {
    if (text.isEmpty) return '?';

    List<String> words = text.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return text[0].toUpperCase();
  }

  // Helper: Build stat card
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Build info tile
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.deepPurple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // Helper: Format date
  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    try {
      DateTime date;
      if (timestamp is Timestamp) {
        date = timestamp.toDate();
      } else if (timestamp is DateTime) {
        date = timestamp;
      } else {
        return 'N/A';
      }
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}