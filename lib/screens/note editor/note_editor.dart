import 'package:flutter/material.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? existingTitle;
  final String? existingContent;

  const NoteEditorScreen({super.key, this.existingTitle, this.existingContent});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingTitle ?? '');
    _contentController = TextEditingController(
      text: widget.existingContent ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    // Logic to save the note to DB/local storage
    Navigator.pop(context); // Go back to home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTitle != null ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(icon: const Icon(Icons.done), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Write your note...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
