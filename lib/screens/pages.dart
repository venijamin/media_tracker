import 'package:flutter/material.dart';
import 'package:media_tracker/data/dummy_data.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/game.dart';
import 'package:media_tracker/models/movie.dart';
import 'package:media_tracker/models/tvshow.dart';
import 'package:media_tracker/screens/add_entry.dart';
import 'package:media_tracker/screens/display/grid_display.dart';
import 'package:media_tracker/screens/display/list_display.dart';
import 'package:media_tracker/screens/view_entry.dart';
import '../models/book.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  State<PagesScreen> createState() => PagesScreenState();
}

final data = DummyData();

class PagesScreenState extends State<PagesScreen> {
  List<Movie> _moviesList = [];
  List<Book> _bookList = [];
  List<Entry> _entryList = [];
  List<Game> _gamesList = [];
  List<Show> _showsList = [];

  List<dynamic> _entriesToShow = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    _moviesList = await data.movieRepository.getAll();
    _bookList = await data.bookRepository.getAll();
    _showsList = await data.showRepository.getAll();
    _gamesList = await data.gameRepository.getAll();

    _entryList = [..._moviesList, ..._bookList, ..._showsList, ..._gamesList];

    setState(() {}); // call setState to rebuild the widget tree
  }

  String? _selectedType;
  bool _isGridDisplay = true;
  @override
  Widget build(BuildContext context) {
    if (_moviesList.isEmpty || _bookList.isEmpty) {
      // return a loading widget if the lists are empty
      return Center(child: CircularProgressIndicator());
    } else {
      var typeMap = {
        'All': _entryList,
        'Book': _bookList,
        'Movie': _moviesList,
        'Show': _showsList,
        'Game': _gamesList,
      };
      void addEntry(String type, dynamic entry) {
        setState(() {
          typeMap[type]!.add(entry);
          getData();
        });
      }

      _selectedType ??= typeMap.keys.first;
      List<dynamic> searchQueryList(String query) {
        List<dynamic> result = typeMap[_selectedType]!
            .where((element) => element.title.contains(query))
            .toList();
        return result;
      }

      _entriesToShow = typeMap[_selectedType]!;
      Widget showEntries = _isGridDisplay
          ? GridDisplayScreen(entries: _entriesToShow)
          : ListDisplayScreen(entries: _entriesToShow);
      return Scaffold(
        appBar: EasySearchBar(
          leading: Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  items: typeMap.keys.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isGridDisplay = !_isGridDisplay;
                });
              },
              icon: _isGridDisplay
                  ? Icon(Icons.list)
                  : Icon(Icons.grid_view_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
            ),
          ],
          putActionsOnRight: true,
          onSearch: (query) {
            setState(() {
              _entriesToShow = searchQueryList(query);
              print(query);
              print(_entriesToShow);

              showEntries = _isGridDisplay
                  ? GridDisplayScreen(entries: _entriesToShow)
                  : ListDisplayScreen(entries: _entriesToShow);
            });
          },
          title: const Text(''),
          suggestions: [for (dynamic entry in _entriesToShow) entry.title],
          suggestionBuilder: (data) {
            return ListTile(
              title: Text(data),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewEntry(
                          entry: (_entriesToShow
                              .firstWhere((element) => element.title == data))),
                    ));
              },
            );
          },
        ),
        body: showEntries,
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            useSafeArea: true,
            builder: (context) => AddEntryScreen(
              onAddEntry: addEntry,
            ),
          ),
        ),
      );
    }
  }
}
