import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/type.dart';

abstract class EntryRepository {
  List<Entry> getAllEntries();
  void replaceEntries(List<Entry> entries);
  Entry getEntryById(String id);
  List<Entry> getEntriesByType(EntryType type);
  List<Entry> getEntriesByCategory(String category);
  List<Entry> getEntriesByTag(String tag);
  List<Entry> getEntriesByTags(List<String> tags);
  List<Entry> getEntriesByTagsAndCategory(List<String> tags, String category);
  void removeEntry(Entry entry);
  void addEntry(Entry entry);
  void editEntry(Entry oldEntry, Entry newEntry);
}
