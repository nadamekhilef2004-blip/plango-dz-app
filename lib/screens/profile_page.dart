import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});  // ← IMPORTANT: const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Profile Image
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 80,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Traveler',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'traveler@example.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            
            // Stats Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard('Trips Planned', '3'),
                  const SizedBox(width: 12),
                  _buildStatCard('Favorites', '8'),
                  const SizedBox(width: 12),
                  _buildStatCard('Reviews', '12'),
                ],
              ),
            ),
            
            // Settings Section
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            _buildSettingTile(
              Icons.notifications,
              'Notifications',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications coming soon!')),
                );
              },
            ),
            _buildSettingTile(
              Icons.language,
              'Language',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language settings coming soon!')),
                );
              },
            ),
            _buildSettingTile(
              Icons.dark_mode,
              'Dark Mode',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dark mode coming soon!')),
                );
              },
            ),
            _buildSettingTile(
              Icons.help,
              'Help & Support',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support coming soon!')),
                );
              },
            ),
            _buildSettingTile(
              Icons.info,
              'About',
              () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('PlanGo Dz'),
                    content: const Text(
                      'Version 1.0.0\n\nYour Algeria Travel Guide\n\nDiscover the beauty of Algeria with PlanGo Dz',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2E7D32)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}