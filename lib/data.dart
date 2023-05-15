import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/repository/entry_repository.dart';
import 'package:media_tracker/repository/impl/entry_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/type.dart';

late SharedPreferences preferences;
List<String> tags = [];
List<String> categories = [];
EntryRepository entryRepository = EntryRepositoryImpl();
bool isDarkModeOn = false;

class Data {
  Data() {
    tags.add('tag1');
    tags.add('tg1');
    tags.add('tg2');
    tags.add('tg3');
    tags.add('t1');
    tags.add('ta');
    tags.add('ta2');
    tags.add('a3');
    tags.add('a1');
    tags.add('a2');
    tags.add('a3');
    tags.add('a1');
    tags.add('a2');
    tags.add('3');
    tags.add('ta1');
    tags.add('a2');
    tags.add('g3');
    categories.add('cat1');
    categories.add('cat2');
    categories.add('cat3');
    categories.add('cat4');

    entryRepository.addEntry(
        Entry(title: 'entry1', type: EntryType.Book, category: 'cat1'));
    entryRepository.addEntry(Entry(title: 'entry2', type: EntryType.Game));
    entryRepository.addEntry(Entry(title: 'entry3', type: EntryType.Movie));
    entryRepository.addEntry(Entry(title: 'entry4', type: EntryType.Show));
  }
}
