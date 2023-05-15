import 'package:media_tracker/data.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/repository/entry_repository.dart';

class EntryRepositoryImpl implements EntryRepository {
  List<Entry> entries = [];

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
