import 'package:flutter/material.dart';

enum EntryType { Game, Book, Show, Movie }

var entryTypeIconMap = {
  EntryType.Book: Icons.book,
  EntryType.Game: Icons.gamepad,
  EntryType.Movie: Icons.movie,
  EntryType.Show: Icons.local_movies_rounded
};
var entryTypeDescriptionMap = {
  EntryType.Book: 'books, manga, comics, ...',
  EntryType.Game: 'video games, board games, ...',
  EntryType.Movie: 'old and new!',
  EntryType.Show: 'tv shows, anime, ...',
};
