import 'package:flutter/material.dart';
import 'package:media_tracker/data/dummy_data.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/movie.dart';
import 'package:media_tracker/screens/display/add_entry.dart';
import 'package:media_tracker/screens/display/grid_display.dart';
import 'package:media_tracker/screens/display/list_display.dart';
import '../models/book.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  State<PagesScreen> createState() => PagesScreenState();
}

class PagesScreenState extends State<PagesScreen> {
  final data = DummyData();

  List<Movie> _moviesList = [];
  List<Book> _bookList = [];
  List<Entry> _entryList = [];

  List<dynamic> _entriesToShow = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    _moviesList = await data.movieRepository.getAll();
    _bookList = await data.bookRepository.getAll();

    _entryList = [..._moviesList, ..._bookList];

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
      };
      _selectedType ??= typeMap.keys.first;
      List<dynamic> searchQueryList(String query) {
        List<dynamic> result = typeMap[_selectedType]!
            .where((element) => element.title.contains(query))
            .toList();
        return result;
      }

      _entriesToShow = typeMap[_selectedType]!;
      return Scaffold(
        appBar: EasySearchBar(
          title: DropdownButtonHideUnderline(
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
            });
          },
        ),
        body: _isGridDisplay
            ? GridDisplayScreen(entries: _entriesToShow)
            : ListDisplayScreen(entries: _entriesToShow),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            useSafeArea: true,
            builder: (context) => AddEntryScreen(),
          ),
        ),
      );
    }
  }
}
