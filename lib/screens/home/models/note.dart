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
