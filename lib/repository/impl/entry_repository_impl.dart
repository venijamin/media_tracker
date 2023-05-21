import 'dart:convert';

import 'package:media_tracker/data.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/repository/entry_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;
Future<List<Entry>> init() async {
  preferences = await SharedPreferences.getInstance();
  String? jsonString = preferences.getString('data');
  var json = jsonDecode(jsonString!);
  print(json);

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
  return entries;
}

class EntryRepositoryImpl implements EntryRepository {
  List<Entry> entries = [];

  Future _init() async {
    entries = await init();
  }

  EntryRepositoryImpl() {
    _init();
  }

  @override
  void addEntry(Entry entry) {
    entries.add(entry);
  }

  @override
  void editEntry(Entry oldEntry, Entry newEntry) {
    int entryIndex = entries.indexOf(oldEntry);
    entries[entryIndex] = newEntry;
  }

  @override
  List<Entry> getAllEntries() {
    return entries;
  }

  @override
  Entry getEntryById(String id) {
    return entries.firstWhere((entry) => entry.id == id);
  }

  @override
  void removeEntry(Entry entry) {
    entries.remove(entry);
  }

  @override
  List<Entry> getEntriesByType(EntryType type) {
    return entries.where((entry) => entry.type == type).toList();
  }

  @override
  List<Entry> getEntriesByCategory(String category) {
    return entries.where((element) => element.category == category).toList();
  }

  @override
  List<Entry> getEntriesByTags(List<String> tags) {
    return entries.where((element) => element.tags.contains(tags)).toList();
  }

  @override
  List<Entry> getEntriesByTagsAndCategory(List<String> tags, String category) {
    return entries
        .where((element) => element.tags.contains(tags))
        .where((element) => element.category == category)
        .toList();
  }

  @override
  List<Entry> getEntriesByTag(String tag) {
    return entries.where((element) => element.tags.contains(tag)).toList();
  }

  @override
  void replaceEntries(List<Entry> entries) {
    this.entries = entries;
    // for (var entry in this.entries) {
    //   print('REMOVING ${entry.title}');
    //   this.entries.remove(entry);
    // }
    // for (var entry in entries) {
    //   print('ADDINFG ${entry.title}');
    //   this.entries.add(entry);
    // }
  }
}
