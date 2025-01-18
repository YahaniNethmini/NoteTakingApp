import 'package:flutter/material.dart';
import 'package:noteapp/screens/add_edit_screen.dart';
import 'package:noteapp/services/database_helper.dart';

import '../model/notes_model.dart';

class ViewNoteScreen extends StatelessWidget {
  final Note note;

  ViewNoteScreen({required this.note});

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return "Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute
          .toString().padLeft(2, '0')}";
    }
    return "${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(
        2, '0')}:${dt.minute.toString()
        .padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditNoteScreen(
                        note: note,
                      ),
                ),
              );
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top colored section with title and date
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _formatDateTime(note.dateTime),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // White container for content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(24),
                    child: Text(
                      note.content,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 1.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Delete Note",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Are you sure you want to delete this note?",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                )
              ],
            )
    );
    if (confirm == true) {
      await _databaseHelper.deleteNotes(note.id!);
      Navigator.pop(context);
    }
  }
}
