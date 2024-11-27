import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Section
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/profile.png'), // Add your profile image here
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            // Name and Email
            Text(
              'John Doe', // Replace with actual name
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'johndoe@example.com', // Replace with actual email
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // Profile Edit Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the Edit Profile screen
                Navigator.pushNamed(context, '/editProfile');
              },
              child: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(height: 10),
            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Implement Logout functionality
              },
              child: const Text('Logout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
