import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response> bookAPIs(String query) async {
  return http.get(
    Uri.parse(query),
    headers: {
      'X-RapidAPI-Key': 'bb4d113ca0msh83e983ba43c1a14p18c08fjsnd6150a8e2648',
      'X-RapidAPI-Host': 'hapi-books.p.rapidapi.com'
    },
  );
}

Future<http.Response> movieAPIs(String query) async {
  return http.get(
    Uri.parse(query),
    headers: {
      'Type': 'get-movies-by-title',
      'X-RapidAPI-Key': 'bb4d113ca0msh83e983ba43c1a14p18c08fjsnd6150a8e2648',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    },
  );
}

Future<http.Response> showAPIs(String query) async {
  return http.get(Uri.parse(query), headers: {
    'Type': 'get-shows-by-title',
    'X-RapidAPI-Key': 'bb4d113ca0msh83e983ba43c1a14p18c08fjsnd6150a8e2648',
    'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
  });
}

Future<http.Response> gameAPIs(String query) async {
  return http.get(Uri.parse(query), headers: {
    'X-RapidAPI-Key': 'bb4d113ca0msh83e983ba43c1a14p18c08fjsnd6150a8e2648',
    'X-RapidAPI-Host': 'computer-games-info.p.rapidapi.com'
  });
}
