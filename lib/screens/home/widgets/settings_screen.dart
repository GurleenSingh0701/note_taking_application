// import 'package:flutter/material.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _isDarkMode = false;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         const Text(
//           'Settings',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 24),
//         _buildSettingsSection('Appearance', [
//           SwitchListTile(
//             title: const Text('Dark Mode'),
//             value: _isDarkMode,
//             onChanged: (value) => setState(() => _isDarkMode = value),
//           ),
//           ListTile(
//             title: const Text('Theme Color'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {}, // TODO: Implement theme color selection
//           ),
//         ]),
//         _buildSettingsSection('Account', [
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Profile'),
//             onTap: () {}, // TODO: Implement profile screen
//           ),
//           ListTile(
//             leading: const Icon(Icons.email),
//             title: const Text('Change Email'),
//             onTap: () {}, // TODO: Implement email change
//           ),
//           ListTile(
//             leading: const Icon(Icons.lock),
//             title: const Text('Change Password'),
//             onTap: () {}, // TODO: Implement password change
//           ),
//         ]),
//         const SizedBox(height: 24),
//         Center(
//           child: ElevatedButton.icon(
//             icon: const Icon(Icons.logout),
//             label: const Text('Sign Out'),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () {}, // TODO: Implement sign out
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSettingsSection(String title, List<Widget> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//           ),
//         ),
//         Card(
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           child: Column(children: items),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle(title: 'Preferences'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: false, // Replace with dynamic state
            onChanged: (bool value) {
              // Toggle theme mode logic here
            },
          ),
          const Divider(height: 32),

          const SectionTitle(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Perform logout
            },
          ),
          const Divider(height: 32),

          const SectionTitle(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: const Text('v1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Navigate to Privacy Policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send Feedback'),
            onTap: () {
              // Open feedback form or email
            },
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
