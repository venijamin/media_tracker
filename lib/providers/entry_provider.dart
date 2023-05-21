import 'package:media_tracker/data.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/repository/entry_repository.dart';
import 'package:media_tracker/repository/impl/entry_repository_impl.dart';
import 'package:riverpod/riverpod.dart';

class EntryNotifier extends StateNotifier<List<Entry>> {
  EntryNotifier() : super([]);

  List<Entry> getAllEntries() {
    return entryRepository.getAllEntries();
  }

  List<Entry> getEntriesByType(EntryType type) {
    return entryRepository.getEntriesByType(type);
  }

  void replaceEntries(List<Entry> entries) {
    return entryRepository.replaceEntries(entries);
  }

  void removeEntry(Entry entry) {
    entryRepository.removeEntry(entry);
  }

  void addEntry(Entry entry) {
    entryRepository.addEntry(entry);
  }

  void editEntry(Entry oldEntry, Entry newEntry) {
    entryRepository.editEntry(oldEntry, newEntry);
  }

  Entry getEntryById(String id) {
    return entryRepository.getEntryById(id);
  }

  List<Entry> getEntryByCategory(String category) {
    return entryRepository.getEntriesByCategory(category);
  }

  List<Entry> getEntryByTags(List<String> tags) {
    return entryRepository.getEntriesByTags(tags);
  }

  List<Entry> getEntryByTagsAndCategory(List<String> tags, String category) {
    return entryRepository.getEntriesByTagsAndCategory(tags, category);
  }
}

final entryProvider = StateNotifierProvider<EntryNotifier, List<Entry>>(
  (ref) {
    return EntryNotifier();
  },
);
