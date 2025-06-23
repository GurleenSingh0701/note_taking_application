import 'package:flutter/material.dart';

class NoteGridView extends StatelessWidget {
  const NoteGridView({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder note list
    final notes = List.generate(10, (index) => "Note #$index");

    return GridView.builder(
      itemCount: notes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(notes[index], style: const TextStyle(fontSize: 16)),
        );
      },
    );
  }
}
