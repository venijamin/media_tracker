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
  Data() {}
}
