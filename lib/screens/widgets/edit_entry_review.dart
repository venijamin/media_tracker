import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show Document, QuillController, QuillEditor, QuillToolbar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/providers/entry_provider.dart';
import 'package:media_tracker/screens/homepage.dart';

import '../../models/entry.dart';

class EditEntryReview extends ConsumerWidget {
  EditEntryReview({super.key, required this.entry});
  Entry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    QuillController _reviewController = QuillController.basic();
    if (!entry.userReview.isEmpty) {
      print(entry.userReview);
      _reviewController = QuillController(
          document: Document.fromJson(entry.userReview),
          selection: const TextSelection.collapsed(offset: 0));
    }
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  ref.read(entryProvider.notifier).editEntry(
                      entry,
                      Entry(
                        title: entry.title,
                        type: entry.type,
                        category: entry.category,
                        description: entry.description,
                        imageURL: entry.imageURL,
                        metadata: entry.metadata,
                        rating: entry.rating,
                        tags: entry.tags,
                        userReview:
                            _reviewController.document.toDelta().toJson(),
                      ));

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePageScreen(),
                      ));
                },
                icon: Icon(Icons.check),
              ),
            ],
          ),
          Text('Thoughts'),
          QuillToolbar.basic(controller: _reviewController),
          SizedBox(height: 10),
          Expanded(
            child: Card(
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: QuillEditor.basic(
                  controller: _reviewController,
                  readOnly: false, // true for view only mode
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
