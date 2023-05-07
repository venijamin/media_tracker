import 'package:flutter/material.dart';

class AddEntryScreen extends StatelessWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final commentController = TextEditingController();

    return SingleChildScrollView(
      child: Column(children: []),
    );
  }
}
