import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/data.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/providers/entry_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/entry.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () async {
// Create the json string
                  String jsonEntries = jsonEncode(
                      ref.read(entryProvider.notifier).getAllEntries());
                  String jsonCategories = jsonEncode(categories);
                  String jsonTags = jsonEncode(tags);
                  var jsonData = {
                    'entries': jsonEntries,
                    'categories': jsonCategories,
                    'tags': jsonTags,
                  };
                  final json = jsonEncode(jsonData);

// Pick a folder to save the file to
                  String? directory =
                      await FilePicker.platform.getDirectoryPath();
                  print(directory);
                  File file = File('${directory}/media_tracker-backup.json');
                  file.writeAsStringSync(json);
                },
                child: Text('Export data')),
            ElevatedButton(
              onPressed: () async {
                // Permission granted, access the file here
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  File file = File(result.files.first.path!);

                  var json = jsonDecode(file.readAsStringSync());
                  var jsonEntries = jsonDecode(json['entries']);
                  var jsonCategories = jsonDecode(json['categories']);
                  var jsonTags = jsonDecode(json['tags']);

                  categories = [];
                  for (var category in jsonCategories) {
                    categories.add(category);
                  }
                  tags = [];
                  for (var tag in jsonTags) {
                    tags.add(tag);
                  }
                  List<Entry> entries = [];
                  for (var jsonEntry in jsonEntries) {
                    final List<String> _tags = [];
                    for (var tag in jsonEntry['tags']) {
                      _tags.add(tag);
                    }
                    EntryType type;
                    print(jsonEntry['type']);
                    print(jsonEntry['type'].runtimeType);
                    if (jsonEntry['type'] == 'Show') {
                      type = EntryType.Show;
                    } else if (jsonEntry['type'] == 'Game') {
                      type = EntryType.Game;
                    } else if (jsonEntry['type'] == 'Movie') {
                      type = EntryType.Movie;
                    } else {
                      type = EntryType.Book;
                    }
                    Entry entry = Entry(
                      title: jsonEntry['title'],
                      type: type,
                      category: jsonEntry['category'],
                      description: jsonEntry['description'],
                      tags: _tags,
                      imageURL: jsonEntry['imageURL'],
                      metadata: jsonEntry['metadata'],
                      rating: jsonEntry['rating'],
                      userReview: jsonEntry['userReview'],
                    );
                    entries.add(entry);
                  }
                  print(entries);
                  ref.read(entryProvider.notifier).replaceEntries(entries);
                }
              },
              child: Text('Import data'),
            ),
          ],
        )
      ]),
    );
  }
}
