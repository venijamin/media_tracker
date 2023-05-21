import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/data.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/providers/dark_mode_provider.dart';
import 'package:media_tracker/providers/entry_provider.dart';
import 'package:media_tracker/screens/homepage.dart';
import 'package:motion/motion.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Motion.instance.initialize();

  Motion.instance.setUpdateInterval(60.fps);
  Data();
  runApp(ProviderScope(child: const MyApp()));
}

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.green);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.green,
);

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      saveData();

// Create the json string
    } else if (state == AppLifecycleState.resumed) {
      init();
    }
  }

  void saveData() {
    String jsonEntries =
        jsonEncode(ref.read(entryProvider.notifier).getAllEntries());
    String jsonCategories = jsonEncode(categories);
    String jsonTags = jsonEncode(tags);
    var jsonData = {
      'entries': jsonEntries,
      'categories': jsonCategories,
      'tags': jsonTags,
    };
    final json = jsonEncode(jsonData);

    preferences.setString('data', json);
    print(json);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    initpref();
    init();
  }

  Future initpref() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future init() async {
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
    ref.read(entryProvider.notifier).replaceEntries(entries);
  }

  @override
  Widget build(BuildContext context) {
    var darkmode = ref.watch(darkModeProvider);
    print(darkmode);
    return MaterialApp(
      theme: darkmode
          ? ThemeData.dark().copyWith(
              useMaterial3: true,
              colorScheme: kDarkColorScheme,
            )
          : ThemeData().copyWith(
              useMaterial3: true,
              colorScheme: kColorScheme,
            ),
      home: HomePageScreen(),
    );
  }
}
