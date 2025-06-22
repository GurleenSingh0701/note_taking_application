import 'package:flutter/material.dart';
import 'package:note_taking_application/screens/home/models/note.dart';
import 'note_card.dart';

class NotesList extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteTap;
  final Function(Note) onNoteLongPress;

  const NotesList({
    super.key,
    required this.notes,
    required this.onNoteTap,
    required this.onNoteLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notes.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: NoteCard(
          note: notes[index],
          isGrid: false,
          onTap: () => onNoteTap(notes[index]),
          onLongPress: () => onNoteLongPress(notes[index]),
        ),
      ),
    );
  }
}
