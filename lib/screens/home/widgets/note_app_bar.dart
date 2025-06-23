import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_application/screens/home/widgets/settings_screen.dart';

class NoteAppBar extends StatelessWidget {
  const NoteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: Future.value(FirebaseAuth.instance.currentUser!.photoURL),
          builder: (context, snapshot) {
            final photoUrl = snapshot.data;
            return CircleAvatar(
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl)
                  : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
            );
          },
        ),
      ),
      title: const Text('NoteKeeper'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }
}
