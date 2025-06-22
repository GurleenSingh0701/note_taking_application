import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_application/login_screen.dart';
import 'package:note_taking_application/screens/home/widgets/settings_screen.dart';
import 'package:note_taking_application/screens/home/widgets/user_menu.dart';
import 'package:note_taking_application/screens/home/models/note.dart';
import 'package:note_taking_application/screens/home/models/navigation_item.dart';
import 'package:note_taking_application/services/notes_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isGridLayout = false;

  static const List<NavigationItem> _navItems = [
    NavigationItem(icon: Icons.notes, label: 'All Notes'),
    NavigationItem(icon: Icons.push_pin, label: 'Pinned'),
    NavigationItem(icon: Icons.star, label: 'Favorites'),
    NavigationItem(icon: Icons.folder, label: 'Folders'),
    NavigationItem(icon: Icons.delete, label: 'Trash'),
    NavigationItem(icon: Icons.archive, label: 'Archived'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    void navigateToSearch(BuildContext context) {
      showSearch(context: context, delegate: NotesSearchDelegate());
    }

    void navigateToNoteEditor(BuildContext context, [Note? note]) {
      // TODO: Implement navigation to note editor
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(note == null ? 'New Note' : 'Edit Note'),
            ),
            body: const Center(child: Text('Note Editor Placeholder')),
          ),
        ),
      );
    }

    if (user == null) {
      Future.microtask(
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        ),
      );
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NoteKeeper',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => navigateToSearch(context),
          ),
          IconButton(
            icon: Icon(_isGridLayout ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridLayout = !_isGridLayout),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => navigateToNoteEditor(context),
          ),
          if (user != null) UserMenu(user: user!),
        ],
      ),
      body: _selectedIndex == _navItems.length ? const SettingsScreen() : null,
      floatingActionButton: isMobile && _selectedIndex != _navItems.length
          ? FloatingActionButton(
              onPressed: () => navigateToNoteEditor(context),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        destinations: [
          for (int i = 0; i < _navItems.length; i++)
            NavigationDestination(
              icon: Icon(_navItems[i].icon),
              label: _navItems[i].label,
            ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index == _navItems.length - 1) {
            _showMoreOptions(context);
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        indicatorColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = _navItems.length;
              });
            },
          ),
          // Add more options here if needed
        ],
      ),
    );
  }
}
