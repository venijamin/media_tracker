import 'package:media_tracker/repository/repository.dart';

class RepositoryImpl<Entry> implements Repository<Entry> {
  final _entries = <Entry>[];

  @override
  Future<List<Entry>> getAll() async {
    return _entries;
  }

  @override
  Future<void> add(Entry entry) async {
    _entries.add(entry);
  }

  @override
  Future<void> update(Entry oldEntry, Entry newEntry) async {
    final int bookIndex = _entries.indexOf(oldEntry);
    _entries[bookIndex] = newEntry;
  }

  @override
  Future<void> delete(Entry entry) async {
    _entries.remove(entry);
  }

  @override
  Future<int> findIndex(Entry entry) async {
    return _entries.indexOf(entry);
  }
}
