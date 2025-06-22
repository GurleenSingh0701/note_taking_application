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
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    // Redirect to login if not authenticated
    if (user == null) {
      Future.microtask(
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        ),
      );
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Define main content area
    Widget mainContent = _selectedIndex == _navItems.length
        ? const SettingsScreen()
        : Center(
            child: Text(
              'Showing: ${_navItems[_selectedIndex].label}',
              style: const TextStyle(fontSize: 20),
            ),
          ); // TODO: Replace with your NotesGrid or NotesList widget

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NoteKeeper',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                showSearch(context: context, delegate: NotesSearchDelegate()),
          ),
          IconButton(
            icon: Icon(_isGridLayout ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridLayout = !_isGridLayout),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToNoteEditor(context),
          ),
          if (user != null) UserMenu(user: user!),
        ],
      ),

      // Responsive body
      body: isMobile
          ? mainContent
          : Row(
              children: [
                _buildNavigationRail(context),
                Expanded(child: mainContent),
              ],
            ),

      // Only mobile bottom bar
      bottomNavigationBar: isMobile ? _buildMobileNavigationBar(context) : null,

      // FAB for mobile only
      floatingActionButton: isMobile && _selectedIndex != _navItems.length
          ? FloatingActionButton(
              onPressed: () => _navigateToNoteEditor(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _navigateToNoteEditor(BuildContext context, [Note? note]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(note == null ? 'New Note' : 'Edit Note')),
          body: const Center(child: Text('Note Editor Placeholder')),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const SettingsScreen(),
    );
  }

  Widget _buildMobileNavigationBar(BuildContext context) {
    return NavigationBar(
      destinations: [
        for (final item in _navItems)
          NavigationDestination(icon: Icon(item.icon), label: item.label),
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
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return NavigationRail(
      useIndicator: true,
      destinations: [
        for (final item in _navItems)
          NavigationRailDestination(
            icon: Icon(item.icon),
            label: Text(item.label),
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
      extended: true,
      elevation: 10,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
