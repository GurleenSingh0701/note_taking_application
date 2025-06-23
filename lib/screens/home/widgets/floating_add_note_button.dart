import 'package:flutter/material.dart';
import 'package:note_taking_application/screens/note%20editor/note_editor.dart';

class FloatingAddNoteButton extends StatelessWidget {
  const FloatingAddNoteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoteEditorScreen()),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
