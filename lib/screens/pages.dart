import 'package:flutter/material.dart';
import 'package:media_tracker/data/dummy_data.dart';
import 'package:media_tracker/models/entry.dart';
import 'package:media_tracker/models/movie.dart';
import '../models/book.dart';

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

  @override
  Widget build(BuildContext context) {
    if (_moviesList.isEmpty || _bookList.isEmpty) {
      // return a loading widget if the lists are empty
      return Center(child: CircularProgressIndicator());
    } else {
      print(_moviesList.first.id);
      print(_bookList.first.isbn);
      print(_entryList.first.id);
      return Container();
    }
  }
}
