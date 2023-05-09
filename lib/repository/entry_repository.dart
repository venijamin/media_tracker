import 'package:media_tracker/models/book.dart';

abstract class EntryRepository<Entry> {
  Future<List<Entry>> getAll();
  List<Entry> getEntries();
  Future<int> findIndex(Entry entry);
  void add(Entry entry);
  Future<void> update(Entry oldEntry, Entry newEntry);
  Future<void> delete(Entry entry);
}
