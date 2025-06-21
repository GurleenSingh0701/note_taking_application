
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isGridLayout = false;
  bool _showPinnedSection = true;
  bool _isDarkMode = false;

  // Navigation items
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
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Defensive: if user vanished, return to login.
    if (user == null) {
      Future.microtask(
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        ),
      );
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'NoteKeeper',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search notes',
              onPressed: () => _navigateToSearch(context),
            ),
            IconButton(
              icon: Icon(_isGridLayout ? Icons.list : Icons.grid_view),
              tooltip: 'Toggle view',
              onPressed: () => setState(() => _isGridLayout = !_isGridLayout),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add new note',
              onPressed: () => _navigateToNoteEditor(context),
            ),
            _buildProfileMenu(context),
          ],
        ),
        drawer: isMobile ? null : _buildDesktopDrawer(theme),
        body: _selectedIndex == _navItems.length
            ? _buildSettingsScreen(theme)
            : _buildContentArea(theme, isMobile),
        floatingActionButton: isMobile && _selectedIndex != _navItems.length
            ? FloatingActionButton(
                onPressed: () => _navigateToNoteEditor(context),
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: isMobile ? _buildBottomNavBar(theme) : null,
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: const [
              Icon(Icons.person, size: 20),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: const [
              Icon(Icons.settings, size: 20),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'sign_out',
          child: Row(
            children: const [
              Icon(Icons.logout, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Sign Out', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'profile') {
          _showProfileDialog(context);
        } else if (value == 'settings') {
          setState(() => _selectedIndex = _navItems.length);
        } else if (value == 'sign_out') {
          _signOut(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 16,
          backgroundImage: user!.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user!.photoURL == null
              ? Text(
                  (user!.displayName ?? '?')[0].toUpperCase(),
                  style: const TextStyle(fontSize: 14),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildDesktopDrawer(ThemeData theme) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: user!.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user!.photoURL == null
                      ? Text(
                          (user!.displayName ?? '?')[0].toUpperCase(),
                          style: const TextStyle(fontSize: 20),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  user!.displayName ?? 'User',
                  style: theme.textTheme.titleMedium,
                ),
                Text(user!.email ?? '', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          ..._navItems.map(
            (item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              selected: _navItems.indexOf(item) == _selectedIndex,
              onTap: () => _onNavItemTapped(_navItems.indexOf(item)),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: _selectedIndex == _navItems.length,
            onTap: () => _onNavItemTapped(_navItems.length),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex >= _navItems.length
          ? _navItems.length
          : _selectedIndex,
      onTap: _onNavItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
      items: [
        ..._navItems
            .sublist(0, 4) // Only show first 4 items on mobile nav
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }

  Widget _buildContentArea(ThemeData theme, bool isMobile) {
    // TODO: Replace with actual notes data based on selected tab
    final notes = List.generate(
      10,
      (index) => Note(
        id: '$index',
        title: 'Note ${index + 1}',
        content: 'This is sample note content ${index + 1}',
        isPinned: index < 3,
        isFavorite: index % 2 == 0,
        lastEdited: DateTime.now().subtract(Duration(days: index)),
      ),
    );

    final pinnedNotes = notes.where((note) => note.isPinned).toList();
    final otherNotes = notes.where((note) => !note.isPinned).toList();

    return CustomScrollView(
      slivers: [
        if (_selectedIndex == 0 && pinnedNotes.isNotEmpty && _showPinnedSection)
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context,
              title: 'Pinned Notes',
              isExpanded: _showPinnedSection,
              onToggle: () =>
                  setState(() => _showPinnedSection = !_showPinnedSection),
            ),
          ),
        if (_selectedIndex == 0 && pinnedNotes.isNotEmpty && _showPinnedSection)
          _isGridLayout
              ? _buildNotesGrid(pinnedNotes)
              : _buildNotesList(pinnedNotes),
        if (_selectedIndex == 0)
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context,
              title: _selectedIndex == 0
                  ? 'All Notes'
                  : _navItems[_selectedIndex].label,
            ),
          ),
        _isGridLayout
            ? _buildNotesGrid(_selectedIndex == 0 ? otherNotes : notes)
            : _buildNotesList(_selectedIndex == 0 ? otherNotes : notes),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    bool isExpanded = true,
    VoidCallback? onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (onToggle != null)
            IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: onToggle,
              splashRadius: 20,
            ),
        ],
      ),
    );
  }

  SliverGrid _buildNotesGrid(List<Note> notes) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildNoteCard(notes[index], true),
        childCount: notes.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    );
  }

  SliverList _buildNotesList(List<Note> notes) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _buildNoteCard(notes[index], false),
        ),
        childCount: notes.length,
      ),
    );
  }

  Widget _buildNoteCard(Note note, bool isGrid) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToNoteDetail(context, note),
        onLongPress: () => _showNoteOptions(context, note),
        child: Padding(
          padding: EdgeInsets.all(isGrid ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (note.isPinned)
                    const Icon(Icons.push_pin, size: 16, color: Colors.orange),
                  if (note.isPinned) const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      note.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isFavorite)
                    const Icon(Icons.star, size: 16, color: Colors.yellow),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: isGrid ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isGrid) const SizedBox(height: 8),
              if (!isGrid)
                Row(
                  children: [
                    Text(
                      _formatDate(note.lastEdited),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsScreen(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildSettingsSection('Appearance', [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (value) => setState(() => _isDarkMode = value),
          ),
          ListTile(
            title: const Text('Theme Color'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO: Implement theme color selection
          ),
        ]),
        _buildSettingsSection('Account', [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => _showProfileDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Change Email'),
            onTap: () => _showChangeEmailDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () => _showChangePasswordDialog(context),
          ),
        ]),
        _buildSettingsSection('Preferences', [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {}, // TODO: Implement notifications settings
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & Sync'),
            onTap: () {}, // TODO: Implement backup settings
          ),
        ]),
        _buildSettingsSection('About', [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About NoteKeeper'),
            onTap: () {}, // TODO: Implement about screen
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Feedback'),
            onTap: () {}, // TODO: Implement help screen
          ),
        ]),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => _signOut(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(children: items),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: user!.displayName);
    final photoController = TextEditingController(text: user!.photoURL);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user!.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user!.photoURL == null
                    ? Text(
                        (user!.displayName ?? '?')[0].toUpperCase(),
                        style: const TextStyle(fontSize: 40),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: photoController,
                decoration: const InputDecoration(
                  labelText: 'Profile Photo URL',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                await user!.updateDisplayName(nameController.text.trim());
              }
              if (photoController.text.trim().isNotEmpty) {
                await user!.updatePhotoURL(photoController.text.trim());
              }
              if (!context.mounted) return;
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Profile updated')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    final controller = TextEditingController(text: user!.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Email'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'New Email',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await user!.verifyBeforeUpdateEmail(controller.text.trim());
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification email sent')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New Password',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await user!.updatePassword(controller.text.trim());
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _navigateToSearch(BuildContext context) {
    showSearch(context: context, delegate: NotesSearchDelegate());
  }

  void _navigateToNoteEditor(BuildContext context, [Note? note]) {
    // TODO: Implement navigation to note editor
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('New Note')),
          body: const Center(child: Text('Note Editor Placeholder')),
        ),
      ),
    );
  }

  void _navigateToNoteDetail(BuildContext context, Note note) {
    // TODO: Implement navigation to note detail
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(note.title)),
          body: Center(child: Text(note.content)),
        ),
      ),
    );
  }

  void _showNoteOptions(BuildContext context, Note note) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.push_pin),
            title: Text(note.isPinned ? 'Unpin' : 'Pin'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Toggle pin status
              setState(() {});
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: Text(
              note.isFavorite ? 'Remove favorite' : 'Add to favorites',
            ),
            onTap: () {
              Navigator.pop(context);
              // TODO: Toggle favorite status
              setState(() {});
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              _navigateToNoteEditor(context, note);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Delete note
            },
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await AuthService().signOut();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Signed out successfully')));
  }

  void _onNavItemTapped(int index) {
    if (index == _navItems.length - 1 &&
        MediaQuery.of(context).size.width < 600) {
      // Show more options for mobile
      _showMoreOptions(context);
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.archive),
            title: const Text('Archived'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = _navItems.indexOf(_navItems[5]));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = _navItems.length);
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class NotesSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: Implement search results
    return Center(child: Text('Results for: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Implement search suggestions
    return Center(child: Text('Suggestions for: $query'));
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem({required this.icon, required this.label});
}

class Note {
  final String id;
  final String title;
  final String content;
  final bool isPinned;
  final bool isFavorite;
  final DateTime lastEdited;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.isPinned = false,
    this.isFavorite = false,
    required this.lastEdited,
  });
}
