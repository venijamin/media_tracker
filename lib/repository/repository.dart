import 'package:media_tracker/models/book.dart';

abstract class Repository<Entry> {
  Future<List<Entry>> getAll();
  Future<int> findIndex(Entry entry);
  Future<void> add(Entry entry);
  Future<void> update(Entry oldEntry, Entry newEntry);
  Future<void> delete(Entry entry);
}
