import 'package:flutter/material.dart';
import 'package:note_taking_application/screens/home/models/note.dart';
import 'note_card.dart';

class NotesGrid extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteTap;
  final Function(Note) onNoteLongPress;

  const NotesGrid({
    super.key,
    required this.notes,
    required this.onNoteTap,
    required this.onNoteLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) => NoteCard(
        note: notes[index],
        isGrid: true,
        onTap: () => onNoteTap(notes[index]),
        onLongPress: () => onNoteLongPress(notes[index]),
      ),
    );
  }
}
