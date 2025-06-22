import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserMenu extends StatelessWidget {
  final User user;

  const UserMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, size: 20),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'sign_out',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Sign Out', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'profile') {
          // TODO: Navigate to profile
        } else if (value == 'settings') {
          // TODO: Navigate to settings
        } else if (value == 'sign_out') {
          // TODO: Handle sign out
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 16,
          backgroundImage: user.photoURL != null
              ? NetworkImage(user.photoURL!)
              : null,
          child: user.photoURL == null
              ? Text(
                  (user.displayName ?? '?')[0].toUpperCase(),
                  style: const TextStyle(fontSize: 14),
                )
              : null,
        ),
      ),
    );
  }
}
