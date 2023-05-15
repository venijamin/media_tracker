import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/type.dart';
import 'package:media_tracker/providers/dark_mode_provider.dart';
import 'package:media_tracker/providers/entry_provider.dart';
import 'package:media_tracker/providers/type_provider.dart';
import 'package:media_tracker/screens/settings.dart';
import 'package:media_tracker/screens/widgets/add_entry.dart';
import 'package:media_tracker/screens/widgets/display/grid_display.dart';
import 'package:media_tracker/screens/widgets/display/list_display.dart';
import 'package:media_tracker/screens/widgets/view_entry.dart';
import 'package:motion/motion.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key});

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

bool _isGridView = true;

class _HomePageScreenState extends ConsumerState<HomePageScreen>
    with WidgetsBindingObserver {
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
      print('YEEYEYEY');
      print('YEEYEYEY');
      print('YEEYEYEY');
      print('YEEYEYEY');
      print('YEEYEYEY');
      print('YEEYEYEY');
      print('YEEYEYEY');
// Create the json string
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
    } else if (state == AppLifecycleState.resumed) {
      init();
    }
  }

  @override
  void initState() {
    super.initState();
    initpref();
    WidgetsBinding.instance!.addObserver(this);
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
    EntryType _selectedType = ref.watch(typeProvider.notifier).getType();
    final entries =
        ref.watch(entryProvider.notifier).getEntriesByType(_selectedType);

    final allEntries = ref.watch(entryProvider.notifier).getAllEntries();
    return Scaffold(
        appBar: AppBar(
          title: DropdownButtonHideUnderline(
            child: DropdownButton<EntryType>(
              value: _selectedType,
              items: EntryType.values.map((type) {
                return DropdownMenuItem<EntryType>(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  ref.read(typeProvider.notifier).changeType(newValue!);
                });
              },
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => showSearch(
                context: context,
                delegate: SearchPage<Entry>(
                  items: allEntries,
                  searchLabel: 'Search entries',
                  suggestion: Center(
                    child: Text(''),
                  ),
                  failure: Center(
                    child: Text('No entry found'),
                  ),
                  filter: (entry) => [
                    entry.title,
                    entry.category,
                    entry.description,
                  ],
                  builder: (entry) => ListTile(
                    title: TextButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => ViewEntryScreen(entry: entry),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(entry.title),
                              Text(entry.description),
                            ],
                          ),
                          Column(
                            children: [
                              if (entry.rating >= 0)
                                Text(entry.rating.toString()),
                              Text(entry.type.name),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  print(_isGridView);
                  _isGridView = !_isGridView;
                });
              },
              icon: _isGridView ? Icon(Icons.list) : Icon(Icons.grid_view),
            ),
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    )),
                icon: Icon(Icons.settings))
          ],
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dark mode:'),
                    Switch(
                      value: ref.watch(darkModeProvider),
                      onChanged: (value) =>
                          ref.read(darkModeProvider.notifier).toggle(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        final _controller = TextEditingController();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            children: [
                              TextField(
                                controller: _controller,
                              ),
                              TextButton(
                                  onPressed: () => setState(() {
                                        if (!categories
                                            .contains(_controller.text)) {
                                          categories.add(_controller.text);
                                        }
                                      }),
                                  child: Text('add'))
                            ],
                          ),
                        );
                      },
                      child: Text('Add new category'),
                    ),
                    TextButton(
                        onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => ListView.builder(
                                itemBuilder: (context, index) => Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          for (var entry in allEntries) {
                                            if (entry.category ==
                                                categories[index]) {
                                              entry.category == '';
                                            }
                                          }
                                          categories.removeAt(index);
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                    Text(
                                      categories[index],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final _controller =
                                            TextEditingController();
                                        _controller.value = TextEditingValue(
                                            text: categories[index]);
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Column(
                                            children: [
                                              TextField(
                                                controller: _controller,
                                              ),
                                              TextButton(
                                                onPressed: () => setState(() {
                                                  if (!categories.contains(
                                                      _controller.text)) {
                                                    for (var entry
                                                        in allEntries) {
                                                      if (entry.category ==
                                                          categories[index]) {
                                                        entry.category =
                                                            _controller.text;
                                                      }
                                                    }
                                                    categories[index] =
                                                        _controller.text;
                                                  }
                                                }),
                                                child: Text('replace'),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                                itemCount: categories.length,
                              ),
                            ),
                        child: Text('View all')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        final _controller = TextEditingController();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            children: [
                              TextField(
                                controller: _controller,
                              ),
                              TextButton(
                                  onPressed: () => setState(() {
                                        if (!tags.contains(_controller.text)) {
                                          tags.add(_controller.text);
                                        }
                                      }),
                                  child: Text('add'))
                            ],
                          ),
                        );
                      },
                      child: Text('Add new tag'),
                    ),
                    TextButton(
                        onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => ListView.builder(
                                itemBuilder: (context, index) => Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          for (var entry in allEntries) {
                                            if (entry.tags
                                                .contains(tags[index])) {
                                              entry.tags.remove(tags[index]);
                                            }
                                          }
                                          tags.removeAt(index);
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                    Text(
                                      tags[index],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final _controller =
                                            TextEditingController();
                                        _controller.value =
                                            TextEditingValue(text: tags[index]);
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Column(
                                            children: [
                                              TextField(
                                                controller: _controller,
                                              ),
                                              TextButton(
                                                onPressed: () => setState(() {
                                                  if (!tags.contains(
                                                      _controller.text)) {
                                                    for (var entry
                                                        in allEntries) {
                                                      if (entry.tags.contains(
                                                          tags[index])) {
                                                        entry.tags[entry.tags
                                                                .indexOf(tags[
                                                                    index])] =
                                                            _controller.text;
                                                      }
                                                    }
                                                    tags[index] =
                                                        _controller.text;
                                                  }
                                                }),
                                                child: Text('replace'),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                                itemCount: tags.length,
                              ),
                            ),
                        child: Text('View all')),
                  ],
                )
              ],
            ),
          ),
        ),
        body: _isGridView
            ? GridDisplayScreen(
                entries: entries,
              )
            : ListDisplayScreen(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Motion(
          shadow: ShadowConfiguration.fromElevation(2),
          child: FloatingActionButton(onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: true,
              useSafeArea: true,
              context: context,
              builder: (context) => AddEntryScreen(),
            );
          }),
        ));
  }
}
